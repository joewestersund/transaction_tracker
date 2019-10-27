# == Schema Information
#
# Table name: repeating_transfers
#
#  id                         :integer          not null, primary key
#  user_id                    :integer
#  from_account_id            :integer
#  to_account_id              :integer
#  amount                     :decimal(, )
#  description                :text
#  repeat_start_date          :date
#  ends_after_num_occurrences :integer
#  ends_after_date            :date
#  repeat_period              :string
#  repeat_every_x_periods     :integer
#  repeat_on_x_day_of_period  :integer
#  last_occurrence_added      :date
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  next_occurrence            :date
#

include RepeatingObjectsHelper

class RepeatingTransfer < ApplicationRecord

  belongs_to :user
  belongs_to :to_account, class_name: "Account"
  belongs_to :from_account, class_name: "Account"

  validates :user_id, presence: true
  validate :from_and_to_accounts_are_not_same
  validates :from_account_id, presence: true
  validates :to_account_id, presence: true
  validates :amount, presence: true, numericality: true

  validates :repeat_start_date, presence:true
  validates :repeat_period, inclusion: { in: %w(day week month) }

  validate :end_date_after_start_date

  validates :repeat_on_x_day_of_period, absence: true, if: repeat_period == 'day' #should be blank if repeat period = "day"
  validates :repeat_on_x_day_of_period, inclusion: 1..7, if: repeat_period == 'week'
  validates :repeat_on_x_day_of_period, inclusion: 1..31, if: repeat_period == 'month'

  before_save :do_initialize_next_occurrence

  def from_and_to_accounts_are_not_same
    self.errors.add(:base, "The 'to' account must be different from the 'from' account.") if self.to_account_id == self.from_account_id
  end

  def end_date_after_start_date
    self.errors.add(:base, "If the 'ends_after_date' is not left blank, it must be on or after the 'repeat_start_date'.") if self.ends_after_date.present? && (self.ends_after_date > self.repeat_start_date)
  end

  def do_initialize_next_occurrence
    RepeatingObjectsHelper.initialize_next_occurrence(self)
  end

end
