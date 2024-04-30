module WeatherDevices
  module ObservationResults
    class Create < Base
      def initialize(device:, observation_params:)
        @observation_params = observation_params
        super(device:)
      end

      def perform
        contract = ::Weather::ResponseContract.new.call(@observation_params.to_h)

        raise ::Errors::InvalidData.new('Invalid data', contract) if contract.failure?

        @device.observations_sources.each do |source|
          source.observations_results.create!(contract.to_h)
        end
      end
    end
  end
end
