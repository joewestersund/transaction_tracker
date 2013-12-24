class CreateTransactionCategories < ActiveRecord::Migration
  def change
    create_table :transaction_categories do |t|
      t.string :user_name
      t.string :name
      t.bool :is_income
      t.integer :order_in_list

      t.timestamps
    end
  end
end
