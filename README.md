# README

#### Intro

Caelus is a weather monitoring app, named after the primordial god of the sky in Roman mythology.

#### Main Feature

Main feature of this app is periodic collection of current weather data from the weather APIs and physical weather monitoring devices which should send their current weather data to the application backend periodically too. Later on at admin panel this data can be observed, analysed and processed for example for some weather research purposes.

#### Features + Techincal Details

Also app provies example of admin panel access permissions by presenting the notion of the `organization_admin` role along with `super_admin` role. `AdminUser` entities can be managed by admins with super admin role.
Super admin also can see and manage all the organisations and their related entites data.
While organisation admins can only manage organsations data to which they are granted access to.

Also admin panel allows `super_admin` users to see the rSwag API documentation and to monitor the state of the sidekiq bacground jobs and scheduled jobs at the 'Settings' menu section. Super admin users also can be managed there.

`Organisation` is presents business concept of some kind of corporate client of this admin panel.
Organisation has such related entites like `WeatherApiCredential` or `WeatherDevice` that can be assigned to the `Observations::Source`. Observation sources attributes contain name and latitude, longitude coordinates which present a poit of interest for the meteorological observations.
All fetched and received data is being saved into the `Observations::Result`.

No matter what the original formats and requests are used at the respective weather apis app processes them to be saved in a unified format at periodic background processing `Weather::SchedulerJob`.

Weather API processing intricacies are incapsulated at the `Weather::OpenWeatherHandler` and `::Weather::AccuWeatherHandler` respectively.

Another implementational example of the simple API client is done at `AccuWeather::Api::Request` that inherits from the `BaseApi::Request` that also provides an example of how the basic API client can be implemented.

### Purpose

Primary purose of the app as a pet project is to showcase some implementation concepts and approaches that can be useful for such tasks like multiple sources data collection and processing.

### Ruby version

`ruby 3.3.1`

### System dependencies to start at local machine

`Docker (Docker Desktop)`, `ruby 3.3.1`

### Configuration at local machine with docker

- Run this command in the terminal `cp docker-compose.yml.example docker-compose.yml` to create docker compose file form the provided example

- Generate random key set with this `DATABASE_URL=dummy DATABASE_PORT=123 DATABASE_USER=dummy bin/rails db:encryption:init` in your termial. Pan no mind onto these weir dummy values they are just needed to load the enviromnent for this command, these values are not involved in the key set generation.
Command output will contain something like this:

```yaml
active_record_encryption:
  primary_key: <your generated primary_key value>
  deterministic_key: <your generated deterministic_key value>
  key_derivation_salt: <your generated key_derivation_salt value>
```

- Inside your local `docker-compose.yml` file at `rails` and `sidekiq` environment sections assign previously generated values at respective variables

```yaml
services:
  rails:
    # ...
    environment:
      # ...
      ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY: <your generated primary_key value>
      ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY: <your generated deterministic_key value>
      ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT: <your generated key_derivation_salt value>
      # ...
  sidekiq:
    # ...
    environment:
      # ...
      ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY: <your generated primary_key value>
      ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY: <your generated deterministic_key value>
      ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT: <your generated key_derivation_salt value>
      # ...
```

- Start project with `SUPER_ADMIN_PASSWORD=your_super_password docker-compose up` (Don't forget to provide your own secure password here instead of `your_super_password`. As it will be the password of the admin user with highest level of access permissions). By default super admin login email is `super.admin@caelus.com`

- During starting process database also will be prepopulated with some demo entities like Organisation and some dummy randomly generated Weather API credentials. (These credentials must be updated with real ones at next steps)

- After docker compose has finished starting up the application, open application domain `http://0.0.0.0:3000/` and enter the created above super admin credentials. It should log in you into the admin panel of the appication.

### Weather APIs Configuration

- Navigate into weather credentials of the dummy `Meteo Tech` organization, (`Organizations -> Meteo Tech -> Weather Api Credentials`)
- Edit `OpenWeather` and `AccuWeather` credentials respectively with your own real api credentials, which you can create registring at their official websites https://openweathermap.org/  https://www.accuweather.com/ Don't worry features that we are using are supported by free subscription plans

- After Weather APIs are properly configured project's background processing current weather data fetching job `Weather::SchedulerJob`, that runs every hour, would finally be able to fetch some data and save it into the database via `Observations::Result` model

### Weather Devices APIs Calls Examples

#### Submit valid data

```
curl -v -H "Content-Type: application/json" -H 'Authorization: Token token=ca63308bc71198be9061fa66ee9cab5e' http://localhost:3000/weather_devices/f8c6ac85-4ee9-4ca9-838c-9df83843e24a/api/observation_results -X POST -d '{ "temperature": 19.0, "pressure": 1016.6, "humidity": 79.0, "wind_speed": 0.9, "wind_deg": 270.0 }'

HTTP/1.1 204 No Content

```

#### Submit invalid data

```
curl -v -H "Content-Type: application/json" -H 'Authorization: Token token=ca63308bc71198be9061fa66ee9cab5e' http://localhost:3000/weather_devices/f8c6ac85-4ee9-4ca9-838c-9df83843e24a/api/observation_results -X POST -d '{ "temperature": 19.0, "pressure": 1016.6, "humidity": 79.0, "wind_speed": null, "wind_deg": null }'

< HTTP/1.1 422 Unprocessable Content

{
  "error": "Invalid data",
  "messages": [
    {
      "wind_speed": "must be a float"
    },
    {
      "wind_deg": "must be a float"
    }
  ]
}

```

#### Invalid token

```
curl -v -H "Content-Type: application/json" -H 'Authorization: Token token=Wrong-Token-ca63308bc71198be9061fa66ee9cab5e' http://localhost:3000/weather_devices/f8c6ac85-4ee9-4ca9-838c-9df83843e24a/api/observation_results -X POST -d '{ "temperature": 19.0, "pressure": 1016.6, "humidity": 79.0, "wind_speed": null, "wind_deg": null }' | jsonpp

HTTP/1.1 401 Unauthorized

```

#### UUID Not Found

```
curl -v -H "Content-Type: application/json" -H 'Authorization: Token token=ca63308bc71198be9061fa66ee9cab5e' http://localhost:3000/weather_devices/f8c6ac85-4ee9-4ca9-838c-9df83843e25a/api/observation_results -X POST -d '{ "temperature": 19.0, "pressure": 1016.6, "humidity": 79.0, "wind_speed": null, "wind_deg": null }'

< HTTP/1.1 404 Not Found
{"error":"Not Found"}

```

### How to run tests

- TBD

### Future improvements and ideas

- Dymanic/Reconfigurable data fetching schedules, might be useful testing or for example or some other use cases, maybe to reduce amount of weather api queries etc

- Use postgis for Observations::Source latitude, longitude handling, that will improve the data integrity and can open way for further interesting features to work with coordinates tracking for example if this data comes from the mobile weather devices like Meteorological Ballons for example

- Use `uuid-ossp` postgres extension for the native support of the UUID values (skipped to avoid issues at heroku deployment)

- Add `Observations::Group` entity that might group some `Observations::Sources` into specific sets of weather sources to process them as close entities for some specific experiment for example

- API to fetch config data by WeatherDevice that device might ask form the backend server

- More weather apis integration and different data collection/processing.

- Rails generator task to setup API calls wrapper class scaffold

- Google Map integration at admin panel for all the coordinates data

- Onboard photo image uploading as recent WeatherDevice onboard camera image that later can be shown at some page with Google Map that shows all the physical WeatherDevice source's along with virtual WeatherApiCredental sources

- Some customizable Alerts/Notifications/Indication when some weather values reach specific thresholds etc

- Some more complex analytics for the received weather data and some forecasting with AI or some algorithms based on the fetched data

- CI and Deployments

- Improve test coverage. At least add more Unit tests and api tests

- Sentry error monitoring

- Add and use code checking tools like Rubocop, License Finder, Brakeman, Bullet, flog and other checks can be further in inside the deploy CI along with the rSpec, rSwag, etc

