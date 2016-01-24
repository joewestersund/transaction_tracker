require 'test_helper'

class TransactionCategoryTest < ActiveSupport::TestCase

  should validate_presence_of :name
  should validate_uniqueness_of(:name).scoped_to(:user_id)
  should validate_presence_of :order_in_list
  should validate_numericality_of(:order_in_list).only_integer.is_greater_than(0)
  should validate_uniqueness_of(:order_in_list).scoped_to(:user_id)
  should validate_presence_of :user_id

end
