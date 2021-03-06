# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  account_name  :string
#  order_in_list :integer
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  should validate_presence_of :account_name
  should validate_uniqueness_of(:account_name).scoped_to(:user_id)
  should validate_presence_of :order_in_list
  should validate_numericality_of(:order_in_list).only_integer.is_greater_than(0)
  should validate_uniqueness_of(:order_in_list).scoped_to(:user_id)
  should validate_presence_of :user_id

end
