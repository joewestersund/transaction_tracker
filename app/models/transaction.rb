# == Schema Information
#
# Table name: transactions
#
#  id                       :integer          not null, primary key
#  transaction_date         :date
#  vendor_name              :string
#  amount                   :decimal(, )
#  description              :text
#  created_at               :datetime
#  updated_at               :datetime
#  user_id                  :integer
#  account_id               :integer
#  transaction_category_id  :integer
#  year                     :integer
#  month                    :integer
#  day                      :integer
#  repeating_transaction_id :integer
#

class Transaction < ApplicationRecord

  belongs_to :user
  belongs_to :account
  belongs_to :transaction_category
  belongs_to :repeating_transaction, optional: true

  validates :user_id, presence: true
  validates :account_id, presence: true
  validates :transaction_category_id, presence: true
  validates :transaction_date, presence: true
  validates :amount, presence: true, numericality: true
  validates :vendor_name, presence: true

  def self.csv_header
    ["Date", "Vendor Name", "Account","Transaction Category","Amount Spent", "Description"]
  end

  def to_csv
    [self.transaction_date, self.vendor_name, self.account.account_name, self.transaction_category.name, self.amount, self.description]
  end

end
