class ScoreboardController < ApplicationController
  def index
    @teams = Team.order(number: :asc).all
    @services = Service.order(id: :asc).all
    @last_check = get_last_check
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
