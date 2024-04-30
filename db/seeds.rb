# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

if Rails.env.development? || Rails.env.production?
  super_admin_email = ENV.fetch('SUPER_ADMIN_EMAIL', 'super.admin@caelus.com')

  # Admin User for development purposes
  # in production admins must have secure passwords
  unless AdminUser.exists?(email: super_admin_email)
    admin_user = AdminUser.create!(
      email: super_admin_email,
      password: ENV.fetch('SUPER_ADMIN_PASSWORD'),
      password_confirmation: ENV.fetch('SUPER_ADMIN_PASSWORD')
    )

    admin_user.add_role(:super_admin)
  end

  organization = Organization.find_by(name: 'Meteo Tech')

  unless organization
    organization = Organization.create!(
      name: 'Meteo Tech', description: 'Meteorological Services Company'
    )
  end

  device = organization.weather_devices.find_by(name: 'Small Weather Station')

  unless device
    device = organization.weather_devices.create!(
      name: 'Small Weather Station',
      description: 'Small Field Weather Station Device',
      token: SecureRandom.hex
    )

    source_name = 'Small Weather Station Source'

    source = organization.weather_devices.find_by(name: source_name)

    unless source
      source = organization.observations_sources.create!(
        latitude: 40.73,
        longitude: -73.93,
        description: 'New York Physical Small Weather Station',
        name: source_name,
        origin: device
      )

      source.observations_results.create!(
        temperature: 19.0, pressure: 1016.6, humidity: 79.0, wind_speed: 0.9, wind_deg: 270.0
      )
    end

    locations =
      [
        {
          city: 'London',
          latitude: 51.51,
          longitude: -0.13,
          description: 'London Physical Weather Station'
        },
        {
          city: 'New York',
          latitude: 40.73,
          longitude: -73.93,
          description: 'New York Physical Weather Station'
        }
      ]

      locations.each do |location|
        source = organization.weather_api_credentials.find_by(name: source_name)

        unless source
          source = organization.observations_sources.create!(
            location.slice(:latitude, :longitude, :description).merge(
              name: source_name,
              origin: credential
            )
          )
        end

        results = [
          { temperature: 7.5, pressure: 1014.0, humidity: 88.0, wind_speed: 11.3, wind_deg: 203.0 },
          { temperature: 6.75, pressure: 1014.0, humidity: 90.0, wind_speed: 2.68, wind_deg: 239.0 },
          { temperature: 19.0, pressure: 1016.6, humidity: 79.0, wind_speed: 0.9, wind_deg: 270.0 }
        ]

        results.each do |result|
          source.observations_results.create!(result)
        end
      end
  end

  WeatherApiCredential::HANDLER_KEYS.each do |handler_key|
    credential = organization.weather_api_credentials.find_by(handler_key:)

    unless credential
      credential =
        organization.weather_api_credentials.create!(
          name: handler_key.camelize,
          handler_key:,
          # This is needed for testing purposes.
          # You need to setup in the database your own api keys for specified
          # weather APIs
          api_key: SecureRandom.hex # Dummy data for database seeding example
        )

      locations =
        [
          {
            city: 'London',
            latitude: 51.51,
            longitude: -0.13,
            description: 'London Virtual Weather Station'
          },
          {
            city: 'New York',
            latitude: 40.73,
            longitude: -73.93,
            description: 'New York Virtual Weather Station'
          }
        ]

      locations.each do |location|
        source_name = [handler_key.camelize, location[:city], 'Source'].join(' ')

        source = organization.observations_sources.find_by(name: source_name)

        unless source
          source = organization.observations_sources.create!(
            location.slice(:latitude, :longitude, :description).merge(
              name: source_name,
              origin: credential
            )
          )
        end

        results = [
          { temperature: 7.5, pressure: 1014.0, humidity: 88.0, wind_speed: 11.3, wind_deg: 203.0 },
          { temperature: 6.75, pressure: 1014.0, humidity: 90.0, wind_speed: 2.68, wind_deg: 239.0 },
          { temperature: 19.0, pressure: 1016.6, humidity: 79.0, wind_speed: 0.9, wind_deg: 270.0 }
        ]

        results.each do |result|
          source.observations_results.create!(result)
        end
      end
    end
  end
end
