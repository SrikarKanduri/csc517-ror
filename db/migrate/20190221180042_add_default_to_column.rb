class AddDefaultToColumn < ActiveRecord::Migration[5.2]
  def change
    change_column_default :user_tours, :num_wait_listed, 0
    change_column_default :user_tours, :num_booked, 0
  end
end
