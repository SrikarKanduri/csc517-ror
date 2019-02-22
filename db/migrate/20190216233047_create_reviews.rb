class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :subject
      t.text :message
      t.integer :user_id

      t.timestamps
    end
  end
end
