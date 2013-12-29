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

class AccountBalance < ActiveRecord::Base
  belongs_to :account
  belongs_to :user

  validates :account_id, presence: true
  validates :balance_date, presence: true
  validates :balance, presence: true

end
