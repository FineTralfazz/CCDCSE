require 'resolv'

class CheckJob < ApplicationJob
  queue_as :default

  def check_http(service, team)
    begin
      response = RestClient.get "http://#{ service.address team }:#{ service.port }"
      response.code == 200
    rescue
      false
    end
  end

  def check_https(service, team)
    begin
      response = RestClient.get "https://#{ service.address team }:#{ service.port }"
      response.code == 200
    rescue
      false
    end
  end

  def check_ssh(service, team)
    begin
      user = team.users.order('RANDOM()').first
      Net::SSH.start service.address(team), user.name, password: user.password do |ssh|
        ssh.exec! 'hostname'
      end
      true
    rescue
      false
    end
  end

  def check_dns(service, team)
    begin
      resolver = Resolv::DNS.new nameserver: service.address(team)
      resolver.getaddress 'example.com'
      true
    rescue
      false
    end
  end

  def perform(service, team)
    success = false
    if service.protocol == 'http'
      success = check_http service, team
    elsif service.protocol == 'https'
      success = check_https service, team
    elsif service.protocol == 'ssh'
      success = check_ssh service, team
    elsif service.protocol == 'dns'
      success = check_dns service, team
    end
    points = success ? 6 : 0
    Check.create team: team, service: service, up: success, points: points
  end
end
