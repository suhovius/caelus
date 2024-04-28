module ActiveAdmin
  module AdminPolicyHelpers
    def is_system_admin?
      admin_user.has_cached_role?(:system_admin)
    end

    def is_organization_admin?(organization = :any)
      admin_user.has_cached_role?(:organization_admin, organization)
    end
  end
end
