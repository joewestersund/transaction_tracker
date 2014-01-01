class ChangeTransactionDateTimeToDate < ActiveRecord::Migration
  def change
    change_column :transactions, :transaction_date, :date
  end
end
