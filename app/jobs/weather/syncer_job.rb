module Weather
  class SyncerJob
    include Sidekiq::Worker

    sidekiq_options queue: 'weather_sync', retry: 1

    def perform(organization_id)
      organization = Organization.find(organization_id)

      ::Weather::Syncer.new(organization: organization).perform
    end
  end
end
