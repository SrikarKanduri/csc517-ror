class AddFieldsToTour < ActiveRecord::Migration[5.2]
  def change
    add_column :tours, :price, :decimal, :precision => 8, :scale => 2
    add_column :tours, :booking_deadline, :datetime
    add_column :tours, :from_date, :date
    add_column :tours, :to_date, :date
    add_column :tours, :op_email, :string, limit 128
    add_column :tours, :op_phone, :string, limit 128
    add_column :tours, :total_seats, :integer
    add_column :tours, :status, :string, limit 128
  end
end
