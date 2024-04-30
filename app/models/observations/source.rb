module Observations
  class Source < ApplicationRecord
    belongs_to :organization
    belongs_to :origin, polymorphic: true

    has_many :observations_results,
             class_name: 'Observations::Result',
             dependent: :destroy

    validates :name, presence: true, uniqueness: { scope: :organization_id }

    # TODO: As a future improvement postgis extension can be used to work with
    # coordinates
    validates :latitude,
              presence: :true,
              numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
    validates :longitude,
              presence: :true,
              numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

    scope :weather_api_credentials, ->{ where(origin_type: 'WeatherApiCredential') }
    scope :weather_devices, ->{ where(origin_type: 'WeatherDevice') }

    attr_accessor :origin_type_and_id # INFO: This is needed for hack in active_admin

    def origin_type_and_id
      @origin_type_and_id || [self.origin_type, self.origin_id].compact.join('-')
    end

    before_validation do
      if origin_type_and_id.present?
        self.origin_type, self.origin_id = origin_type_and_id.split('-')
      end
    end
  end
end
