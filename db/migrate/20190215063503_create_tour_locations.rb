class CreateTourLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :tour_locations do |t|
      t.string :country
      t.string :state_or_province
      t.boolean :starting_point
      t.references :tour

      t.timestamps
    end
  end
end
