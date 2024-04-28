module ActiveAdmin
  module OrganizationAdminFullAccess
    # For records that have organization_id and accessible to org admins

    collection_actions = [:create, :index].freeze
    record_actions = [:show, :update, :destroy].freeze

    collection_actions.each do |action|
      define_method("#{action}?") do
        is_system_admin? || is_organization_admin?
      end
    end

    record_actions.each do |action|
      define_method("#{action}?") do
        is_system_admin? || (
          is_organization_admin? && admin_user.assigned_organization_ids.include?(record.organization_id)
        )
      end
    end

    class Scope < AdminPolicy::Scope
      def resolve_for_additional_roles
        if is_organization_admin?
          scope.where(organization_id: admin_user.assigned_organization_ids)
        end
      end
    end
  end
end
