class AdminController < ApplicationController
  def index
    @scoring_enabled = scoring_enabled
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

  def toggle_scoring
    if request.post?
      current_status = scoring_enabled
      Redis.current.set('scoring_enabled', current_status ? '0' : '1')
      redirect_to '/admin', notice: "Scoring #{current_status ? 'disabled' : 'enabled'}."
    end
  end

  def score_all
    if scoring_enabled
      QueueChecksJob.perform_later
      redirect_to '/admin', notice: "Scoring job queued."
    else
      redirect_to '/admin', alert: "Can't score services while scoring is disabled!"
    end
  end

  private
  def scoring_enabled
    Redis.current.get('scoring_enabled') == '1'
  end
end
