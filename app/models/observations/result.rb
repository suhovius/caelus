module Observations
  class Result < ApplicationRecord
    belongs_to :source, class_name: 'Observations::Source'

    validates :temperature, :pressure, :humidity, :wind_speed, :wind_deg,
              presence: true
  end
end
