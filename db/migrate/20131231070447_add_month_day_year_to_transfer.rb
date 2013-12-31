class AddMonthDayYearToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :year, :integer
    add_column :transfers, :month, :integer
    add_column :transfers, :day, :integer

    add_index :transfers, :to_account_id
    add_index :transfers, :from_account_id
  end
end
