FactoryBot.define do
  factory :observations_source, class: Observations::Source do
    association(:organization)
    association(:origin, factory: :weather_device)

    sequence(:name) { |n| "#{n}-#{FFaker::Lorem.word}" }
    description { FFaker::Lorem.sentence }

    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }

    trait :device_origin do
      association(:origin, factory: :weather_device)
    end

    trait :api_credential_origin do
      association(:origin, factory: :weather_api_credential)
    end
  end
end
