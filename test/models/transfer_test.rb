# == Schema Information
#
# Table name: transfers
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  from_account_id :integer
#  to_account_id   :integer
#  transfer_date   :date
#  amount          :decimal(, )
#  description     :text
#  created_at      :datetime
#  updated_at      :datetime
#  year            :integer
#  month           :integer
#  day             :integer
#

require 'test_helper'

class TransferTest < ActiveSupport::TestCase

  should validate_presence_of :user_id
  should validate_presence_of :from_account_id
  should validate_presence_of :to_account_id
  should validate_presence_of :transfer_date
  should validate_presence_of :amount
  should validate_numericality_of(:amount)

  test "from and to accounts should not be the same" do
    t = transfers(:t1)
    assert t.valid?
    t.from_account_id = t.to_account_id
    assert !t.valid?
  end

end
