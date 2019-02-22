class AddForeignKeyToTourLocations < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :tour_locations, :tours
    add_index :tour_locations, :tour
  end
end
