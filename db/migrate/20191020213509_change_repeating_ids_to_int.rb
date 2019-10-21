class ChangeRepeatingIdsToInt < ActiveRecord::Migration[5.1]
  def up
    change_column :repeating_transactions, :id, :integer
    change_column :repeating_transfers, :id, :integer
  end

  def down
    change_column :repeating_transactions, :id, :bigint
    change_column :repeating_transfers, :id, :bigint
  end
end
