class RemoveIsIncomeFromTc < ActiveRecord::Migration
  def change
    remove_column :transaction_categories, :is_income
  end
end
