require 'resolv'

class CheckJob < ApplicationJob
  queue_as :default

  def check_http(service, team)
    begin
      response = RestClient.get "http://#{ service.address team }:#{ service.port }"
      return response.code == 200, "Response: #{ response.code }"
    rescue
      return false, 'Connection error'
    end
  end

  def check_https(service, team)
    begin
      response = RestClient.get "https://#{ service.address team }:#{ service.port }"
      return response.code == 200, "Response: #{ response.code }"
    rescue
      return false, 'Connection error'
    end
  end

  def check_ssh(service, team)
    begin
      user = team.users.order('RANDOM()').first
      Net::SSH.start service.address(team), user.name, password: user.password do |ssh|
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
      resolver.getaddress 'example.com'
      return true, ''
    rescue
      return false, 'Lookup failed'
    end
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
    end

    points = success ? 6 : 0

    if success
      service.consecutive_fails = 0
    else
      if service.consecutive_fails == 5
        service.consecutive_fails = 0
        points = -25
        details += ' [SLA violation]'
      else
        service.consecutive_fails += 1
      end
    end

    service.save
    Check.create team: team, service: service, up: success, points: points, details: details
    team.points += points
    team.save
  end
end
