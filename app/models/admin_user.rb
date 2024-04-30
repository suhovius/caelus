class AdminUser < ApplicationRecord
  rolify role_cname: 'AdminRole'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  has_many :assigned_organizations,
           through: :roles,
           source: :organization

  scope :resource_type, ->(type) { joins(:roles).where('admin_roles.resource_type = ?', type) }

  def organization_access?(organization)
    has_cached_role?(:organization_admin, organization) || has_cached_role?(:super_admin)
  end

  def admin?
    has_any_role?(
      :super_admin,
      name: :organization_admin,
      resource: :any
    )
  end

  def organization_access?(organization)
    has_cached_role?(:organization_admin, organization) || has_cached_role?(:super_admin)
  end

  def accessible_observation_results
    if has_cached_role?(:super_admin)
      Observations::Result.all
    else
      Observations::Result.joins(:source).where(
        observations_sources: {
          organization_id: assigned_organizations.pluck(:id)
        }
      )
    end
  end

  def accessible_observation_sources
    if has_cached_role?(:super_admin)
      Observations::Source.all
    else
      Observations::Source.where(
        organization_id: assigned_organizations.pluck(:id)
      )
    end
  end
end
