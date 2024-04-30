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
      if origin_type == 'WeatherApiCredential'
        if parent.weather_api_credentials.exists?(id: origin_id)
          permitted += [:origin_type_and_id]
        end
      end
    end

    permitted
  end

  index do
    column :name do |credential|
      link_to credential.name, admin_organization_observations_source_path(organization, credential)
    end

    column :description

    column :latitude
    column :longitude

    column :google_maps_link do |credential|
      link_to('Open at Google Maps', credential.decorate.google_maps_link, target: '_blank')
    end

    column :created_at
    column :updated_at
  end

  show do |credential|
    attributes_table do
      row :name do |credential|
        link_to credential.name, admin_organization_observations_source_path(organization, credential)
      end

      row :description

      row :latitude
      row :longitude

      row :google_maps_link do
        link_to('Open at Google Maps', credential.decorate.google_maps_link, target: '_blank')
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
              collection: organization.weather_api_credentials.map { |item| [item.name, [item.class.name, item.id].join('-')] },
              label: 'Origin',
              selected: f.object.origin_type_and_id

      f.input :latitude
      f.input :longitude
    end

    f.actions
  end
end
