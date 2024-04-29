class CreateObservationsResults < ActiveRecord::Migration[7.1]
  def change
    create_table :observations_results do |t|
      t.references :source,
                   null: false,
                   foreign_key: { to_table: :observations_sources }

      t.float :temperature, null: false
      t.float :pressure, null: false
      t.float :humidity, null: false
      t.float :wind_speed, null: false
      t.float :wind_deg, null: false

      t.timestamps
    end
  end
end
