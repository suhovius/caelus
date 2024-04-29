module ActiveAdmin
  class WeatherApiCredentialPolicy < AdminPolicy
    include FullAccessForOrganizationAdmin
  end
end
