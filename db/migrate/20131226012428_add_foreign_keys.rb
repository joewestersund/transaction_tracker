class AddForeignKeys < ActiveRecord::Migration
  def change
    add_column :accounts, :user_id, :integer
    add_column :transactions, :user_id, :integer
    add_column :transaction_categories, :user_id, :integer

    add_column :transactions, :account_id, :integer
    add_column :transactions, :transaction_category_id, :integer

  end
end
