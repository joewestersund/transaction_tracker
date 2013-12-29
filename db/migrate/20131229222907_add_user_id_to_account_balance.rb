class AddUserIdToAccountBalance < ActiveRecord::Migration
  def change
    add_column :account_balances, :user_id, :integer
  end
end
