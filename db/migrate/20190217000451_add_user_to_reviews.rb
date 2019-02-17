class AddUserToReviews < ActiveRecord::Migration[5.2]
  def change
    remove_column :reviews, :user_id, :integer
    add_reference :reviews, :user, foreign_key: true, index: true
    # add_foreign_key :reviews, :users
  end
end
