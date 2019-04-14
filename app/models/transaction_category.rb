# == Schema Information
#
# Table name: transaction_categories
#
#  id            :integer          not null, primary key
#  name          :string
#  order_in_list :integer
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#

class TransactionCategory < ApplicationRecord

  belongs_to :user
  has_many :transactions

  validates :name, presence: true, :uniqueness => {:scope => :user}
  validates :order_in_list, presence: true, numericality: { only_integer: true, greater_than: 0 }, :uniqueness => {:scope => :user}
  validates :user_id, presence: true

  before_destroy :check_no_transactions

  private
    def check_no_transactions
      status = true
      if self.transactions.count > 0
        self.errors[:deletion_status] = 'Cannot delete a category that is being used for one or more transactions.'
        status = false
      end
      status
    end

end
