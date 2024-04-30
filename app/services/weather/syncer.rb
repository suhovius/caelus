module Weather
  class Syncer
    def initialize(organization:)
      @organization = organization
    end

    def perform
      api_credentials_sources.each do |source|
        handler = prepare_handler_by(origin: source.origin)
        data = fetch_weather_data_by(handler:, source:)

        source.observations_results.create!(data.to_h)
      rescue BaseApi::Errors::Response => e
        # TODO: This should be sent to some error trackers like sentry
        ::Rails.logger.error(e.message)
      end
    end

    private

    def api_credentials_sources
      @organization.observations_sources
                   .weather_api_credentials
                   .preload(:origin)
    end

    def prepare_handler_by(origin:)
      Weather.for(origin.handler_key.to_sym).new(api_key: origin.api_key)
    end

    def fetch_weather_data_by(handler:, source:)
      handler.current_conditions_by_coordinates(
        lat: source.latitude, lon: source.longitude
      )
    end
  end
end
