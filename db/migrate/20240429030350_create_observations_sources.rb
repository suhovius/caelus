class CreateObservationsSources < ActiveRecord::Migration[7.1]
  def change
    create_table :observations_sources do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :origin, polymorphic: true, null: false
      t.string :name, null: false
      t.text :description
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end

    add_index :observations_sources, %i[name organization_id], unique: true
  end
end
