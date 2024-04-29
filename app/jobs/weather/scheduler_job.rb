require 'sidekiq-scheduler'

module Weather
  class SchedulerJob
    include Sidekiq::Worker

    def perform
      Organization.all.each do |organization|
        ::Weather::SyncerJob.perform_async(organization.id)
      end
    end
  end
end
