module ActiveAdmin
  class PagePolicy < AdminPolicy
    # can :read, ActiveAdmin::Page, name: 'Dashboard'

    def show?
      return true if is_system_admin?

      case record.name
      when 'Dashboard'
        true
      else
        false
      end
    end
  end
end
