module AccuWeather
  module Api
    class Request < ::BaseApi::Request
      BASE_URL = 'http://dataservice.accuweather.com'.freeze

      DEFAULT_REQUEST_HEADERS = {
        'Content-Type'    => 'application/json',
        'Accept'          => 'application/json',
        'Accept-Encoding' => 'gzip',
        'Connection'      => 'keep-alive'
      }.freeze

      def initialize(base_url: BASE_URL, headers: {}, options: {}, params: {}, api_key:)
        headers = DEFAULT_REQUEST_HEADERS.merge(headers)

        super(
          base_url: base_url,
          headers: DEFAULT_REQUEST_HEADERS.merge(headers),
          params: params.merge(apikey: api_key),
          options: {
            process_response_body: true,
            trailing_slash: false,
            supported_content_types: ['application/json']
          }.merge(options)
        )
      end

      # ====================== API Calls Definitions ==========================

      def cities_geoposition_search(q:)
        run_request(
          verb: :get,
          path: 'locations/v1/cities/geoposition/search',
          data: { q: }
        )
      end

      def current_conditions(location_key:, details: true)
        path = ['currentconditions/v1', location_key].join('/')
        run_request(verb: :get, path: , data: { details: })
      end

      def current_conditions_by_coordinates(lat:, lon:)
        result = cities_geoposition_search(q: [lat, lon].join(','))

        location_key = result['Key']

        current_conditions(location_key:)
      end
    end
  end
end
