ActiveAdmin.register WeatherDevice do
  belongs_to :organization

  menu false

  config.batch_actions = false

  permit_params :name, :token, :description

  index do
    column :name do |device|
      link_to device.name, admin_organization_weather_device_path(organization, device)
    end

    column :uuid
    column :description
    column :created_at
    column :updated_at
  end

  show do |device|
    attributes_table do
      row :name do |device|
        link_to device.name, admin_organization_weather_device_path(organization, device)
      end
      row :uuid
      row :token
      row :description
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name

      f.input :token,
              hint:
              <<~HINT.squish
                This token must be used by the weater device to push weather
                updates to be backend server
              HINT

      f.input :description
    end

    f.actions
  end
end
