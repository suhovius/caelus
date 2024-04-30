ActiveAdmin.register WeatherApiCredential do
  belongs_to :organization

  menu false

  config.batch_actions = false

  permit_params :name, :handler_key, :api_key

  index do
    column :name do |credential|
      link_to credential.name, admin_organization_weather_api_credential_path(organization, credential)
    end

    column :handler_key
    column :created_at
    column :updated_at
  end

  show do |credential|
    attributes_table do
      row :name do |credential|
        link_to credential.name, admin_organization_weather_api_credential_path(organization, credential)
      end

      row :api_key
      row :handler_key
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name

      if f.object.new_record?
        f.input :handler_key,
                as: :select,
                collection: ::WeatherApiCredential::HANDLER_KEYS.map { |key| [key.camelize, key] }
      end

      f.input :api_key
    end

    f.actions
  end
end
