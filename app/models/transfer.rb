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
#  year            :integer
#  month           :integer
#  day             :integer
#

class Transfer < ApplicationRecord

  belongs_to :to_account, class_name: "Account"
  belongs_to :from_account, class_name: "Account"
  belongs_to :user

  validates :user_id, presence: true
  validate :from_and_to_accounts_are_not_same
  validates :from_account_id, presence: true
  validates :to_account_id, presence: true
  validates :transfer_date, presence: true
  validates :amount, presence: true, numericality: true

  def from_and_to_accounts_are_not_same
    self.errors.add(:base, "The 'to' account must be different from the 'from' account.") if self.to_account_id == self.from_account_id
  end
end
