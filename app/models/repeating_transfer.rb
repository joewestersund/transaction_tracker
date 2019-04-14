# == Schema Information
#
# Table name: repeating_transfers
#
#  id                         :bigint(8)        not null, primary key
#  user_id                    :integer
#  from_account_id            :integer
#  to_account_id              :integer
#  amount                     :decimal(, )
#  description                :text
#  repeat_start_date          :date
#  ends_after_num_occurrences :integer
#  ends                       :string
#  after_date                 :date
#  repeat_period              :string
#  repeat_every_x_periods     :integer
#  repeat_on_x_day_of_period  :integer
#  last_occurrence_added      :date
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class RepeatingTransfer < ApplicationRecord
  belongs_to :user
  belongs_to :to_account, class_name: "Account"
  belongs_to :from_account, class_name: "Account"

  validates :user_id, presence: true
  validate :from_and_to_accounts_are_not_same
  validates :from_account_id, presence: true
  validates :to_account_id, presence: true
  validates :amount, presence: true, numericality: true

  def from_and_to_accounts_are_not_same
    self.errors.add(:base, "The 'to' account must be different from the 'from' account.") if self.to_account_id == self.from_account_id
  end
end
