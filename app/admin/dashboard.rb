# frozen_string_literal: true
ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    observations_results = current_admin_user.accessible_observation_results.joins(:source)

    columns do
      column do
        panel 'Observations count by sources' do
          pie_chart(
            observations_results.group('observations_sources.name').count
          )
        end
      end

      column do
        panel 'Average temperatures by sources' do
          column_chart(
            observations_results.group('observations_sources.name').average(:temperature)
          )
        end
      end
    end

    columns do
      column do
        panel 'Weather Data changes by sources' do
          sources = current_admin_user.accessible_observation_sources

          %w[temperature pressure humidity wind_speed wind_deg].each do |attr_name|
            panel attr_name.humanize do
              line_chart(
                sources.map do |source|
                  {
                    name: source.name,
                    data: source.observations_results.group_by_hour(:created_at).average(attr_name)
                  }
                end
              )
            end
          end
        end
      end
    end
  end
end
