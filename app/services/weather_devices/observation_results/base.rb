module WeatherDevices
  module ObservationResults
    class Base
      def initialize(device:)
        @device = device
      end

      def perform
        raise NotImplementedError.new("#{self.class}##{__method__} is not implemented!")
      end
    end
  end
end
