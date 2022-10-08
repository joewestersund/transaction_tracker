class AddWorkoutType < ActiveRecord::Migration[7.0]
  def change
    create_table :workout_types do |t|
      t.belongs_to :user
      t.string :name
      t.integer :order_in_list

      t.timestamps
    end
    add_index :workout_types, [:user_id, :order_in_list]
  end
end
