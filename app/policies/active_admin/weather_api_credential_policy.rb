module ActiveAdmin
  class WeatherApiCredentialPolicy < AdminPolicy
    include OrganizationAdminFullAccess
  end
end
