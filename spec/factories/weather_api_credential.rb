FactoryBot.define do
  factory :weather_api_credential, class: WeatherApiCredential do
    association(:organization)
    sequence(:name) { |n| "#{n}-#{FFaker::Lorem.word}" }
    handler_key { WeatherApiCredential::HANDLER_KEYS.sample }
    api_key { SecureRandom.hex }
  end
end
