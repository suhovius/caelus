module WeatherDevices
  module Api
    class ObservationResultsController < BaseController
      def create
        ::WeatherDevices::ObservationResults::Create.new(
          device: current_device, observation_params:
        ).perform

        head :no_content
      end

      private

      def observation_params
        params.permit(:temperature, :pressure, :humidity, :wind_speed, :wind_deg)
      end
    end
  end
end
