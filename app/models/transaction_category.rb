# == Schema Information
#
# Table name: transaction_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  is_income     :boolean
#  order_in_list :integer
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#

class TransactionCategory < ActiveRecord::Base

  belongs_to :user
  has_many :transactions

  validates :order_in_list, numericality: { only_integer: true, greater_than: 0 }
  validates :user_id, presence: true

end
