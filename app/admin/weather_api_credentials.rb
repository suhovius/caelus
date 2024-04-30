ActiveAdmin.register WeatherApiCredential do
  belongs_to :organization

  menu false

  config.batch_actions = false

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :organization_id, :name, :handler_key, :api_key
  #
  # or
  #
  permit_params :name, :handler_key, :api_key

  index do
    column :name do |credential|
      link_to credential.name, admin_organization_weather_api_credential_path(organization, credential)
    end

    column :handler_key
    column :created_at
    column :updated_at
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
