class ScoreboardController < ApplicationController
  def index
    @teams = Team.all
    @services = Service.all
  end

  def show
    @team = Team.find params[:team_id]
    @checks = Check.where(team: @team).order created_at: :desc
  end
end
