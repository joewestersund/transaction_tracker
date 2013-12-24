class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.datetime :date
      t.string :vendor_name
      t.decimal :amount
      t.text :description

      t.timestamps
    end
  end
end
