ActiveAdmin.register AdminUser, as: 'SystemAdmin' do
  menu label: 'System admins',
    parent: 'System configuration',
    priority: 2,
    if: -> { current_admin_user.has_cached_role?(:system_admin) }

  config.batch_actions = false
  config.filters = false

  actions :all, except: :destroy
  permit_params :email, :password

  action_item :revoke_access, only: [:edit, :show] do
    link_to(
      'Revoke access',
      revoke_access_admin_system_admin_path(resource),
      method: :put
    )
  end

  member_action :revoke_access, method: :put do
    if current_admin_user == resource
      redirect_back fallback_location: admin_system_admin_path,
                    error: 'You can\'t perform this action'
    else
      resource.revoke :system_admin
      resource.destroy unless resource.admin?
      redirect_to admin_system_admins_path,
                  notice: 'Access has been revoked'
    end
  end

  form do |f|
    f.inputs 'Admin Details' do
      f.input :email
      f.input :password
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at
      row :updated_at
    end
  end

  index do
    column :email
    column :created_at
    actions
  end

  controller do
    after_action :grant_system_access, only: [:create]

    def scoped_collection
      end_of_association_chain.with_role(:system_admin).preload(:roles)
    end

    private

    def authorized?(_action, _subject = nil)
      current_admin_user.has_role? :system_admin
    end

    def grant_system_access
      resource&.grant :system_admin
    end
  end
end
