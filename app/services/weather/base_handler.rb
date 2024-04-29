module Weather
  class BaseHandler
    class InvalidData < StandardError; end

    def initialize(api_key:)
      @api_key = api_key
      @api_client = initialize_api_client
    end

    def current_conditions_by_coordinates(lat:, lon:)
      raise NotImplementedError.new("#{self.class}##{__method__} is not implemented!")
    end

    private

    def initialize_api_client
      raise NotImplementedError.new("#{self.class}##{__method__} is not implemented!")
    end

    def process_response_contract(contract)
      raise InvalidData.new(contract.errors.to_h) if contract.failure?
      contract
    end
  end
end
