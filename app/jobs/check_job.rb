require 'resolv'

class CheckJob < ApplicationJob
  queue_as :default

  def random_user(team)
    return team.users.order('RANDOM()').first
  end

  def check_http(service, team)
    begin
      response = RestClient::Request.execute method: :get, url: "http://#{ service.address team }", timeout: 5
      if service.arg1
        match = response.body.include? service.arg1
        return response.code == 200 && match, "Response: #{ response.code }, content match: #{ match }"
      else
        return response.code == 200, "Response: #{ response.code }"
      end
    rescue
      return false, 'Connection error'
    end
  end

  def check_https(service, team)
    begin
      response = RestClient::Request.execute method: :get, url: "https://#{ service.address team }", timeout: 5
      if service.arg1
        match = response.body.include? service.arg1
        return response.code == 200 && match, "Response: #{ response.code }, content match: #{ match }"
      else
        return response.code == 200, "Response: #{ response.code }"
      end
    rescue
      return false, 'Connection error'
    end
  end

  def check_ssh(service, team)
    begin
      user = random_user team
      Net::SSH.start service.address(team), user.name, password: user.password, timeout: 5, number_of_password_prompts: 0, non_interactive: true do |ssh|
        ssh.exec! 'hostname'
      end
      return true, "#{ user.name }/#{ user.password }"
    rescue
      return false, "#{ user.name }/#{ user.password }"
    end
  end

  def check_dns(service, team)
    begin
      resolver = Resolv::DNS.new nameserver: service.address(team)
      resolver.timeouts = 5
      resolver.getaddress 'example.com'
      return true, ''
    rescue
      return false, 'Lookup failed'
    end
  end

  def check_smb(service, team)
    begin
      user = random_user team
      sock = TCPSocket.new service.address(team), 445
      dispatcher = RubySMB::Dispatcher::Socket.new sock, read_timeout: 5
      client = RubySMB::Client.new dispatcher, smb1: true, smb2: true, username: user.name, password: user.password, domain: service.arg2
      client.negotiate
      client.authenticate
      tree = client.tree_connect "\\\\#{ service.address(team) }\\#{ service.arg1 }"
      log = ''
      tree.list.each do |f|
        log += "#{ f.file_name.encode('utf-8') }, "
      end
      tree.disconnect!
      client.disconnect!
      return true, log
    rescue => e
      return false, "Unable to connect: #{ e.message }"
      puts e.backtrace
    end
  end

  def is_sla_violation(service, team)
    Check.where(service: service, team: team).last(4).each do |check|
      if check.sla_violation
        return false
      end
    end
    return true
  end

  def perform(service, team)
    success = false
    if service.protocol == 'http'
      success, details = check_http service, team
    elsif service.protocol == 'https'
      success, details = check_https service, team
    elsif service.protocol == 'ssh'
      success, details = check_ssh service, team
    elsif service.protocol == 'dns'
      success, details = check_dns service, team
    elsif service.protocol == 'smb'
      success, details = check_smb service, team
    end

    points = success ? 6 : 0
    sla_violation = false

    unless success
      sla_violation = is_sla_violation service, team
      if sla_violation
        details += ' [SLA violation]'
        points = -25
      end
    end

    Check.create team: team, service: service, up: success, points: points, details: details, sla_violation: sla_violation
    team.with_lock do
      team.reload
      team.points = team.points + points
      team.save
    end
  end
end
