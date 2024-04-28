module ActiveAdmin
  class AdminPolicy
    attr_reader :admin_user, :record

    include AdminPolicyHelpers

    def initialize(admin_user, record)
      @admin_user = admin_user
      @record = record
    end

    # can :manage, :all if admin_user.has_cached_role? :system_admin

    def index?
      is_system_admin?
    end

    def show?
      is_system_admin?
    end

    def create?
      is_system_admin?
    end

    def new?
      create?
    end

    def update?
      is_system_admin?
    end

    def edit?
      update?
    end

    def destroy?
      is_system_admin?
    end

    class Scope
      attr_reader :admin_user, :scope

      include AdminPolicyHelpers

      def initialize(admin_user, scope)
        @admin_user = admin_user
        @scope = scope
      end

      def resolve
        if is_system_admin?
          scope.all
        else
          resolve_for_additional_roles || scope.none
        end
      end

      # Method for convenience to avoid repeating checks for system admin
      def resolve_for_additional_roles
        scope.none
      end
    end
  end
end
