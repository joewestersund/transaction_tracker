# == Schema Information
#
# Table name: repeating_transfers
#
#  id                         :integer          not null, primary key
#  user_id                    :integer
#  from_account_id            :integer
#  to_account_id              :integer
#  amount                     :decimal(, )
#  description                :text
#  repeat_start_date          :date
#  ends_after_num_occurrences :integer
#  ends_after_date            :date
#  repeat_period              :string
#  repeat_every_x_periods     :integer
#  repeat_on_x_day_of_period  :integer
#  last_occurrence_added      :date
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  next_occurrence            :date
#

require 'test_helper'

class RepeatingTransferTest < ActiveSupport::TestCase

  should validate_presence_of :user_id
  should validate_presence_of :from_account_id
  should validate_presence_of :to_account_id
  should validate_presence_of :amount
  should validate_numericality_of(:amount)

  test "from and to accounts should not be the same" do
    t = transfers(:t1)
    assert t.valid?
    t.from_account_id = t.to_account_id
    assert !t.valid?
  end

end
