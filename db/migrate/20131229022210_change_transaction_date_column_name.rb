class ChangeTransactionDateColumnName < ActiveRecord::Migration
  def change
    rename_column :transactions, :date, :transaction_date
  end
end
