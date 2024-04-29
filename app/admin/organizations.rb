ActiveAdmin.register Organization do
  menu priority: 0

  filter :name, as: :select, multiple: true

  actions :all, except: :destroy

  permit_params :name, :description

  scope_to :current_admin_user,
           association_method: :assigned_organizations,
           unless: proc { current_admin_user.has_role? :system_admin }

  show do |organization|
    attributes_table do
      row :name
      row :description
      row :created_at
      row :updated_at
    end
  end

  index do
    column :name do |organization|
      link_to organization.name, admin_organization_path(organization)
    end

    column :description
    column :created_at
    column :updated_at
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description
    end

    f.actions
  end

  can_manage_resource = -> { authorized?(:update, resource) }

  sidebar 'Manage People', only: [:show, :edit], if: can_manage_resource do
    ul do
      li link_to 'Organization Admins', admin_organization_organization_admins_path(resource)
    end
  end

  sidebar 'Manage Tools', only: [:show, :edit], if: can_manage_resource do
    ul do
      li link_to 'Weather API Credentials', admin_organization_weather_api_credentials_path(resource)
      li link_to 'Observations Sources', admin_organization_observations_sources_path(resource)
    end
  end

  controller do
    def index
      unless current_admin_user.has_role? :system_admin
        if current_admin_user.assigned_organizations.count == 1
          redirect_to(
            admin_organization_path(current_admin_user.assigned_organizations.first)
          ) and return
        end
      end

      super
    end
  end
end
