class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :activated, :boolean
    add_column :users, :password_reset_sent_at, :datetime
    add_column :users, :reset_password_token, :string
  end
end
