class CreateWeatherApiCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :weather_api_credentials do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.string :handler_key, null: false
      t.string :api_key, null: false

      t.timestamps
    end

    add_index :weather_api_credentials, %i[name organization_id], unique: true
  end
end
