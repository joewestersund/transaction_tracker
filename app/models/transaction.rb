# == Schema Information
#
# Table name: transactions
#
#  id                      :integer          not null, primary key
#  transaction_date        :datetime
#  vendor_name             :string(255)
#  amount                  :decimal(, )
#  description             :text
#  created_at              :datetime
#  updated_at              :datetime
#  user_id                 :integer
#  account_id              :integer
#  transaction_category_id :integer
#  year                    :integer
#  month                   :integer
#  day                     :integer
#

class Transaction < ActiveRecord::Base

  belongs_to :user
  belongs_to :account
  belongs_to :transaction_category

  validates :user_id, presence: true
  validates :account_id, presence: true
  validates :transaction_category_id, presence: true
  validates :transaction_date, presence: true
  validates :amount, presence: true

end
