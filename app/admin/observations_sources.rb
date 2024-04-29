ActiveAdmin.register Observations::Source, as: 'ObservationsSource' do
  belongs_to :organization

  menu false

  config.batch_actions = false

  permit_params do
    permitted = [:name, :description, :latitude, :longitude]

    origin_type_and_id = params.dig('observations_source', 'origin_type_and_id')

    if origin_type_and_id.present?
      origin_type, origin_id = origin_type_and_id.split('-')

      # TODO: Update this condition when Device entity will be added as source
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

    # TODO: Consider using postgis in future for native
    # coordinates processing and validation
    column :latitude
    column :longitude

    column :created_at
    column :updated_at
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
