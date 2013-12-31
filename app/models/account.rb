# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  account_name  :string(255)
#  order_in_list :integer
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#

class Account < ActiveRecord::Base

  belongs_to :user
  has_many :transactions
  has_many :account_balances, :dependent => :destroy
  has_many :incoming_transfers, source: "to_account_id", :dependent => :destroy
  has_many :outgoing_transfers, source: "from_account_id", :dependent => :destroy

  validates :order_in_list, numericality: { only_integer: true, greater_than: 0 }
  validates :user_id, presence: true

end
