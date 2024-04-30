class CreateWeatherDevices < ActiveRecord::Migration[7.1]
  def change
    create_table :weather_devices do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.string :uuid
      t.string :token
      t.text :description

      t.timestamps
    end

    add_index :weather_devices, %i[name organization_id], unique: true
  end
end
