class CreateAccountBalances < ActiveRecord::Migration
  def change
    create_table :account_balances do |t|
      t.integer :account_id
      t.date :balance_date
      t.decimal :balance

      t.timestamps
    end
  end
end
