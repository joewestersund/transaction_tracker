# == Schema Information
#
# Table name: account_balances
#
#  id           :integer          not null, primary key
#  account_id   :integer
#  balance_date :date
#  balance      :decimal(, )
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :integer
#

require 'spec_helper'

describe AccountBalance do
  pending "add some examples to (or delete) #{__FILE__}"
end
