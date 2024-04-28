module ActiveAdmin
  class OrganizationPolicy < AdminPolicy
    organization_actions = [:update]

    organization_actions.each do |action_name|
      define_method("#{action_name}?") do
        is_system_admin? || is_organization_admin?(record)
      end
    end

    def index?
      is_system_admin? || is_organization_admin?
    end

    def show?
      is_system_admin? ||
        is_organization_admin?(record)
    end

    def assign_organization_admin?
      is_system_admin?
    end

    class Scope < AdminPolicy::Scope
      def resolve_for_additional_roles
        if is_organization_admin?
          scope.where(id: admin_user.assigned_organization_ids)
        end
      end
    end
  end
end
