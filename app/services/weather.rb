module Weather
  HANDLERS = {
    open_weather: ::Weather::OpenWeatherHandler,
    accu_weather: ::Weather::AccuWeatherHandler
  }.freeze

  class UnknownHandler < StandardError; end

  class << self
    def for(handler_key)
      HANDLERS[handler_key] || raise(UnknownHandler, ['Handler', handler_key, 'is unknown'].join(' '))
    end
  end
end
