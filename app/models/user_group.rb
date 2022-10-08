# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  created_at      :datetime
#  updated_at      :datetime
#  name            :string
#
class UserGroup < ApplicationRecord
  has_many :accounts, :dependent => :nil # do nothing to users if user_group deleted

  validates :name, presence: true, length: { maximum: 50}, uniqueness: true  #enforce uniqueness across all users
end
