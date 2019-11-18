class AdminController < ApplicationController
  def index
  end

  def reset_points
    if request.post?
      Team.all.each do |team|
        team.points = 0
        team.save
      end
      Check.delete_all
    end
    redirect_to '/admin', notice: "Game reset"
  end

  def game_status
  end
end
