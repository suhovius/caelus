FactoryBot.define do
  factory :weather_device, class: WeatherDevice do
    association(:organization)
    sequence(:name) { |n| "#{n}-#{FFaker::Lorem.word}" }
    description { FFaker::Lorem.sentence }
    token { SecureRandom.hex }
  end
end
