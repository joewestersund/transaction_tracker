class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :user_id
      t.integer :from_account_id
      t.integer :to_account_id
      t.date :transfer_date
      t.decimal :amount
      t.text :description

      t.timestamps
    end
  end
end
