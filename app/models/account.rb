# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  account_name  :string(255)
#  order_in_list :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Account < ActiveRecord::Base
end
