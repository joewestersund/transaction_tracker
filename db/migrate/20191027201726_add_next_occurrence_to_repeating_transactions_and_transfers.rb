class AddNextOccurrenceToRepeatingTransactionsAndTransfers < ActiveRecord::Migration[5.1]
  def change
    add_column :repeating_transactions, :next_occurrence, :date
    add_column :repeating_transfers, :next_occurrence, :date
  end
end
