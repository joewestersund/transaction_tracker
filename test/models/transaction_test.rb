# == Schema Information
#
# Table name: transactions
#
#  id                       :integer          not null, primary key
#  transaction_date         :date
#  vendor_name              :string
#  amount                   :decimal(, )
#  description              :text
#  created_at               :datetime
#  updated_at               :datetime
#  user_id                  :integer
#  account_id               :integer
#  transaction_category_id  :integer
#  year                     :integer
#  month                    :integer
#  day                      :integer
#  repeating_transaction_id :integer
#

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
