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

class AccountBalance < ApplicationRecord
  belongs_to :account
  belongs_to :user

  validates :account_id, presence: true
  validates :balance_date, presence: true
  validates :balance_date, :uniqueness => {:scope => :account, message: "you've already entered balance information for this account for this day"} #can't have two balances on same day for same account
  validates :balance, presence: true, numericality: true
  validates :user_id, presence: true

end
