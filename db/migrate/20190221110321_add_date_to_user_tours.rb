class AddDateToUserTours < ActiveRecord::Migration[5.2]
  def change
    add_column :user_tours, :waitlisted_at, :datetime
  end
end
