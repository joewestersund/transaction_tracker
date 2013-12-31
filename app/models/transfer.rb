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
#

class Transfer < ActiveRecord::Base
end
