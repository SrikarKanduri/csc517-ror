class CreateUserTours < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tours do |t|
      t.references :user, foreign_key: true
      t.references :tour, foreign_key: true

      t.boolean :booked
      t.integer :num_booked
      t.boolean :wait_listed
      t.integer :num_wait_listed
      t.boolean :bookmarked

      t.timestamps
    end
  end
end
