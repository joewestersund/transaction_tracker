# == Schema Information
#
# Table name: repeating_transactions
#
#  id                         :integer          not null, primary key
#  user_id                    :integer
#  vendor_name                :string
#  account_id                 :integer
#  transaction_category_id    :integer
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

class RepeatingTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
