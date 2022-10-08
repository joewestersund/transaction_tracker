class AddUserGroupToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :user_group, index: true
  end
end
