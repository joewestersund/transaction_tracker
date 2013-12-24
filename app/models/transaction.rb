# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  date        :datetime
#  vendor_name :string(255)
#  amount      :decimal(, )
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Transaction < ActiveRecord::Base
end
