class WeatherApiCredential < ApplicationRecord
  belongs_to :organization

  has_many :observations_sources,
           as: :origin,
           class_name: 'Observations::Source',
           dependent: :destroy

  encrypts :api_key

  validates :api_key, presence: true
  validates :name, uniqueness: { scope: :organization_id }, presence: true

  HANDLER_KEYS = %w[accu_weather open_weather].freeze

  validates :handler_key, presence: true, inclusion: { in: HANDLER_KEYS }
end
