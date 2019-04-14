class CreateRepeatingTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :repeating_transactions do |t|
      t.integer :user_id
      t.string :vendor_name
      t.integer :account_id
      t.integer :transaction_category_id
      t.decimal :amount
      t.text :description
      t.date :repeat_start_date
      t.integer :ends_after_num_occurrences
      t.date :ends_after_date
      t.string :repeat_period
      t.integer :repeat_every_x_periods
      t.integer :repeat_on_x_day_of_period
      t.date :last_occurrence_added

      t.timestamps
    end
  end
end
