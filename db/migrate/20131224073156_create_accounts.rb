class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :account_name
      t.integer :order_in_list

      t.timestamps
    end
  end
end
