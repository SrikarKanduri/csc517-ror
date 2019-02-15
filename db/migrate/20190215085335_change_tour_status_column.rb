class ChangeTourStatusColumn < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      ALTER TABLE tours MODIFY status enum('In Future', 'Completed', 'Cancelled');
    SQL
  end

  def down
    change_column :tours, :status, :string
  end
end
