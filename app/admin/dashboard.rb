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
        panel 'Most active source data for the recent day' do

        end
      end
    end

    # TODO: Add some weather graphs by different allowed to current role sources!

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
