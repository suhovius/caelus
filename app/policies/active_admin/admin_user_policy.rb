module ActiveAdmin
  class AdminUserPolicy < AdminPolicy
    def index?
      is_system_admin? || is_organization_admin?
    end

    def create?
      index?
    end

    def create_organization_admin?
      is_system_admin? || is_organization_admin?
    end

    def assign?
      is_system_admin?
    end

    [:show, :update, :revoke_access].each do |action|
      define_method("#{action}?") do
        if is_system_admin?
          true
        elsif is_organization_admin?
          record.roles.where(
            resource_type: 'Organization',
            resource_id: admin_user.assigned_organization_ids
          ).exists?
        else
          false
        end
      end
    end

    class Scope < AdminPolicy::Scope
      def resolve_for_additional_roles
        if is_organization_admin?
          scope.joins(:roles).where(admin_roles: { resource_type: 'Organization', resource_id: admin_user.assigned_organization_ids })
        end
      end
    end
  end
end
