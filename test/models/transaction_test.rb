require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  should validate_presence_of :user_id
  should validate_presence_of :account_id
  should validate_presence_of :transaction_category_id
  should validate_presence_of :vendor_name
  should validate_presence_of :transaction_date
  should validate_presence_of :amount
  should validate_numericality_of(:amount)

end
