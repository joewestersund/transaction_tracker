require 'test_helper'

class AccountBalanceTest < ActiveSupport::TestCase

  should validate_presence_of :user_id
  should validate_presence_of :account_id
  should validate_presence_of :balance_date
  should validate_presence_of :balance
  should validate_numericality_of(:balance)
  should validate_uniqueness_of(:balance_date).scoped_to(:account_id).with_message("you've already entered balance information for this account for this day")

end