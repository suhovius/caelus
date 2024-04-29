module Weather
  class OpenWeatherHandler < BaseHandler
    def current_conditions_by_coordinates(lat:, lon:)
      result = @api_client.current_weather(lat:, lon:)

      contract = ::Weather::ResponseContract.new.call(
        temperature: result.main.temp&.to_f,
        pressure: result.main.pressure&.to_f,
        humidity: result.main.humidity&.to_f,
        wind_speed: result.wind.speed&.to_f,
        wind_deg: result.wind.deg&.to_f
      )

      process_response_contract(contract)
    end

    private

    def initialize_api_client
      OpenWeather::Client.new(api_key: @api_key, units: 'metric')
    end
  end
end
