class AddIndexOnTransferUserIdAndDate < ActiveRecord::Migration[5.1]
  def change
    add_index :transfers, [:user_id, :transfer_date], order: {user_id: :asc, transfer_date: :desc}
  end
end
