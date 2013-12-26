class RemoveUserNameFromTransactionCategories < ActiveRecord::Migration
  def change
    remove_column :transaction_categories, :user_name
  end
end
