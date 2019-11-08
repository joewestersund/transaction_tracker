class AddIndexOnTransactionUserIdAndDate < ActiveRecord::Migration[5.1]
  def change
    add_index :transactions, [:user_id, :transaction_date], order: {user_id: :asc, transaction_date: :desc}
  end
end
