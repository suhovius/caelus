require 'integration_helper'

RSpec.describe 'Weather Devices / Api / Observation Results ', type: :request do
  path '/weather_devices/{uuid}/api/observation_results' do
    # ==========================================================
    post 'Create new observation result' do
      tags 'Weather Devices'

      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'

      description 'Endpoint that allows weather devices to submit their data'

      let!(:organization) { create(:organization) }
      let!(:weather_device) { create(:weather_device, organization: organization) }

      let!(:observations_source) do
        create(:observations_source, organization: organization, origin: weather_device)
      end

      ### PARAMETERS

      security [http_token_auth: []]
      parameter name: :uuid, in: :path, schema: { type: :string }, required: true

      parameter name: :request_body, in: :body, schema: {
        type: :object,
        properties: {
          temperature: { type: :float },
          pressure: { type: :float },
          humidity: { type: :float },
          wind_speed: { type: :float },
          wind_deg: { type: :float },
        }
      }

      ### VARS

      let(:Authorization) { auth_header_for(weather_device.token) }

      let(:uuid) { weather_device.uuid }

      let!(:request_body) do
        {
          temperature: 19.0,
          pressure: 1016.6,
          humidity: 79.0,
          wind_speed: 0.9,
          wind_deg: 270.0
        }
      end

      shared_examples 'success response' do |context_description: nil|
        response 204, 'Succesfull data saving' do
          it nested_description(context_description, 'weather data saved') do |example|
            expect {
              submit_request(example.metadata)
              assert_response_matches_metadata(example.metadata)
            }.to change { Observations::Result.count }.by(1)

            result = Observations::Result.last

            expect(result)

            expect(result.temperature).to eql request_body[:temperature]
            expect(result.pressure).to eql request_body[:pressure]
            expect(result.humidity).to eql request_body[:humidity]
            expect(result.wind_speed).to eql request_body[:wind_speed]
            expect(result.wind_deg).to eql request_body[:wind_deg]
          end
        end
      end

      context '204 success' do
        it_behaves_like 'success response', context_description: self.description
      end
    end
  end
end
