ActiveAdmin.register Observations::Source, as: 'ObservationsSource' do
  belongs_to :organization

  menu false

  config.batch_actions = false

  permit_params do
    permitted = [:name, :description, :latitude, :longitude]

    origin_type_and_id = params.dig('observations_source', 'origin_type_and_id')

    if origin_type_and_id.present?
      origin_type, origin_id = origin_type_and_id.split('-')

      # TODO: Update this condition when WeatherDevice entity will be added as source
      # for the weather data
      case origin_type
      when 'WeatherApiCredential'
        if parent.weather_api_credentials.exists?(id: origin_id)
          permitted += [:origin_type_and_id]
        end
      when 'WeatherDevice'
        if parent.weather_devices.exists?(id: origin_id)
          permitted += [:origin_type_and_id]
        end
      end
    end

    permitted
  end

  index do
    column :name do |source|
      link_to source.name, admin_organization_observations_source_path(organization, source)
    end

    column :origin do |source|
      case source.origin.class.name
      when 'WeatherApiCredential'
        link_to source.origin.name, admin_organization_weather_api_credential_path(organization, source.origin)
      when 'WeatherDevice'
        link_to source.origin.name, admin_organization_weather_device_path(organization, source.origin)
      end
    end

    column :description

    column :latitude
    column :longitude

    column :google_maps_link do |source|
      link_to('Open at Google Maps', source.decorate.google_maps_link, target: '_blank')
    end

    column :created_at
    column :updated_at
  end

  show do |source|
    attributes_table do
      row :name do |source|
        link_to source.name, admin_organization_observations_source_path(organization, source)
      end

      row :origin do
        case source.origin.class.name
        when 'WeatherApiCredential'
          link_to source.origin.name, admin_organization_weather_api_credential_path(organization, source.origin)
        when 'WeatherDevice'
          link_to source.origin.name, admin_organization_weather_device_path(organization, source.origin)
        end
      end

      row :description

      row :latitude
      row :longitude

      row :google_maps_link do
        link_to('Open at Google Maps', source.decorate.google_maps_link, target: '_blank')
      end

      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description
      f.input :origin_type_and_id,
              as: :select,
              collection: (organization.weather_api_credentials + organization.weather_devices).map { |item| [item.name, [item.class.name, item.id].join('-')] },
              label: 'Origin',
              selected: f.object.origin_type_and_id

      f.input :latitude
      f.input :longitude
    end

    f.actions
  end
end
