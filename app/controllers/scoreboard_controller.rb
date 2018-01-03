class ScoreboardController < ApplicationController
  def index
    @teams = Team.all
    @services = Service.all
    @last_check = Check.last.created_at
  end

  def show
    @team = Team.find params[:team_id]
    @checks = Check.where(team: @team).order created_at: :desc
  end

  def last_check
    render json: {last_check: "#{ Check.last.created_at }"}
  end
end
