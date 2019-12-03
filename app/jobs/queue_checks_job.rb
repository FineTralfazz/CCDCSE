class QueueChecksJob < ApplicationJob
  queue_as :default

  def perform(*args)
    if Redis.current.get('scoring_enabled') == '1'
      Service.all.each do |service|
        Team.all.each do |team|
          CheckJob.perform_later service, team
        end
      end
    end
  end
end
