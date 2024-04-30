module WeatherDevices
  module Api
    class BaseController < ActionController::Base
      skip_forgery_protection

      before_action :authenticate

      rescue_from Errors::InvalidData, with: :render_invalid_data_error

      private

      def current_device
        @current_device ||= WeatherDevice.find_by!(uuid: params[:uuid])
      end

      def authenticate
        authenticate_or_request_with_http_token do |token, _options|
          ActiveSupport::SecurityUtils.secure_compare(token, current_device.token)
        end
      end

      def render_invalid_data_error(error)
        messages = error.contract.errors.messages.map do |message|
          { message.path.join('.') => message.text }
        end

        render status: 422, json: { error: , messages:  }
      end
    end
  end
end
