class AddWorkoutRoutes < ActiveRecord::Migration[7.0]
  def change
    create_table :workout_routes do |t|
      t.belongs_to :user
      t.belongs_to :workout
      t.belongs_to :route
      t.integer :repetitions
      t.text :description

      t.timestamps
    end
  end
end
