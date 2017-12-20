class ScoreboardController < ApplicationController
  def index
    @teams = Team.all
    @services = Service.all
  end
end
