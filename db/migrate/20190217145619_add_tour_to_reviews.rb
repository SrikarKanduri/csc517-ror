class AddTourToReviews < ActiveRecord::Migration[5.2]
  def change
    add_reference :reviews, :tour, foreign_key: true, index: true
  end
end
