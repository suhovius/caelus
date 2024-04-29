ActiveAdmin.register Observations::Result, as: 'ObservationsResult' do
  menu priority: 5

  config.batch_actions = false

  actions :index, :show
end
