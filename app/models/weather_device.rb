class WeatherDevice < ApplicationRecord
  belongs_to :organization

  has_many :observations_sources,
           as: :origin,
           class_name: 'Observations::Source',
           dependent: :destroy

  encrypts :token

  validates :token, presence: true
  validates :name, uniqueness: { scope: :organization_id }, presence: true

  # TODO: It is better to use uuid-ossp postgres extension for the UUIDs
  # but to avoid issues at heroku deployments it is done in such way

  after_initialize :assign_uuid, if: :new_record?
  validates :uuid, presence: true, uniqueness: true

  def assign_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
