class Organization < ApplicationRecord
  resourcify :admin_roles, role_cname: 'AdminRole'
  validates :name, presence: true, uniqueness: true, length: { maximum: 80 }
  validates :description, length: { maximum: 500 }

  has_many :weather_api_credentials, dependent: :destroy
  has_many :observations_sources,
           class_name: 'Observations::Source',
           dependent: :destroy

  has_many :observations_results,
           through: :observations_sources

  def assigned_admins
    admins = admin_roles.where(name: :organization_admin).first&.admin_users
    admins || AdminUser.none
  end
end
