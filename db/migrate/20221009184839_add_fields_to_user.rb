class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :activated, :boolean
    add_column :users, :password_reset_sent_at, :datetime
    add_column :users, :reset_password_token, :string
    add_column :users, :current_mode, :integer

    # mark each existing user as activated
    User.all.each do |u|
      u.activated = true
      u.current_mode = 0
      u.save!
    end
  end
end
