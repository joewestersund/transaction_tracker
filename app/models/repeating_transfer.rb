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
  validates :repeat_every_x_periods, inclusion: { in: 1..366 }

  validate :end_date_after_start_date
  validate :repeat_on_x_day_is_in_range

  def repeat_on_x_day_is_in_range
    valid = false
    if self.repeat_period == 'day'
      valid = true
    elsif self.repeat_period == 'week'
      unless (1..7).include?(self.repeat_on_x_day_of_period)
        self.errors.add(:base, "For a weekly repeat, the 'repeat on x day of period' must be between 1 and 7.")
      end
    elsif self.repeat_period == 'month'
      unless (1..31).include?(self.repeat_on_x_day_of_period)
        self.errors.add(:base, "For a weekly repeat, the 'repeat on x day of period' must be between 1 and 7.")
      end
    end

  end

  def from_and_to_accounts_are_not_same
    if self.to_account_id == self.from_account_id
      self.errors.add(:base, "The 'to' account must be different from the 'from' account.")
    end
  end

  def end_date_after_start_date
    if self.ends_after_date.present? && (self.ends_after_date < self.repeat_start_date)
      self.errors.add(:base, "If the 'ends_after_date' is not left blank, it must be on or after the 'repeat_start_date'.")
    end
  end

  def create_instance()
    t = Transfer.new
    t.user = self.user
    t.from_account = self.from_account
    t.to_account = self.to_account
    t.amount = self.amount
    t.description = "#{self.description} added by repeating transfer #{self.id}"
    t.transfer_date = self.next_occurrence
    t.year = self.next_occurrence.year
    t.month = self.next_occurrence.month
    t.day = self.next_occurrence.day
    if not t.save
      raise t.errors
    end

    self.last_occurrence_added = self.next_occurrence

  end

  def end_type
    #these choices are used to determine which options show up in the interface
    if self.ends_after_num_occurrences.present?
      return 'num-occurrences'
    elsif self.ends_after_date.present?
      return 'end-date'
    else
      return 'never'
    end
  end

end
