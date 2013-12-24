# == Schema Information
#
# Table name: transaction_categories
#
#  id            :integer          not null, primary key
#  user_name     :string(255)
#  name          :string(255)
#  is_income     :boolean
#  order_in_list :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class TransactionCategory < ActiveRecord::Base
end
