module Weather
  class AccuWeatherHandler < BaseHandler
    def current_conditions_by_coordinates(lat:, lon:)
      result = @api_client.current_conditions_by_coordinates(lat:, lon:)

      item = result.first

      contract = ::Weather::ResponseContract.new.call(
        temperature: item.dig('Temperature', 'Metric', 'Value')&.to_f,
        pressure: item.dig('Pressure', 'Metric', 'Value')&.to_f,
        humidity: item['RelativeHumidity']&.to_f,
        wind_speed: item.dig('Wind', 'Speed', 'Metric', 'Value')&.to_f,
        wind_deg: item.dig('Wind', 'Direction', 'Degrees')&.to_f
      )

      process_response_contract(contract)
    end

    private

    def initialize_api_client
      ::AccuWeather::Api::Request.new(api_key: @api_key)
    end
  end
end
