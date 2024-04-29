ActiveAdmin.register Organization do
  menu priority: 0

  filter :name
  filter :description
  filter :created_at
  filter :updated_at

  actions :all, except: :destroy

  permit_params :name, :description

  scope_to :current_admin_user,
           association_method: :assigned_organizations,
           unless: proc { current_admin_user.has_role?(:super_admin) }

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

  sidebar 'Entities', only: [:show, :edit], if: -> { authorized?(:update, resource) } do
    ul do
      li link_to 'Organization Admins', admin_organization_organization_admins_path(resource)
      li link_to 'Weather API Credentials', admin_organization_weather_api_credentials_path(resource)
      li link_to 'Observations Sources', admin_organization_observations_sources_path(resource)
      # TODO: Add organization_id filter to observations results and use it here as a parameter
      # li link_to 'Observations Results', admin_organization_observations_results_path(resource)
    end
  end
end
