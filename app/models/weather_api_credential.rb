class WeatherApiCredential < ApplicationRecord
  belongs_to :organization

  encrypts :api_key

  validates :api_key, presence: true
  validates :name, uniqueness: { scope: :organization_id }, presence: true

  HANDLER_KEYS = %w[accu_weather open_weather].freeze

  validates :handler_key, presence: true, inclusion: { in: HANDLER_KEYS }
end
