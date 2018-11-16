class ScoreboardController < ApplicationController
  http_basic_authenticate_with name: 'admin', password: ENV['CCDCSE_ADMIN_PASS'], except: [:index, :last_check, :as_json]

  def index
    @teams = Team.order(number: :asc).all
    @services = Service.order(id: :asc).all
    @last_check = get_last_check
  end

  def as_json
    result = { teams: [] }
    services = Service.order(id: :asc).all
    Team.order(number: :asc).all.each do |team|
      team_result = { number: team.number, points: team.points }
      team_result[:services] = []
      services.each do |service|
        last_check = service.checks.where(team: team).last
        service_result = { name: service.name, up: last_check.up }
        team_result[:services] << service_result
      end
      result[:teams] << team_result
    end
    render json: result
  end

  def show
    @team = Team.find_by number: params[:team_id]
    @checks = Check.where(team: @team).order created_at: :desc
  end

  def last_check
    render json: {last_check: "#{ Check.last.created_at }"}
  end

  private
  def get_last_check
    last = Check.last
    if last
      last.created_at
    else
      nil
    end
  end
end
