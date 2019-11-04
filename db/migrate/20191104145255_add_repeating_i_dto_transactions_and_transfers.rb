class AddRepeatingIDtoTransactionsAndTransfers < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :repeating_transaction_id, :integer
    add_column :transfers, :repeating_transfer_id, :integer
  end
end
