class AddDayMonthYearToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :year, :integer
    add_column :transactions, :month, :integer
    add_column :transactions, :day, :integer

    add_index :transactions, :transaction_category_id
    add_index :transactions, :account_id
  end
end
