# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  account_name  :string
#  order_in_list :integer
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#

class Account < ApplicationRecord

  belongs_to :user
  has_many :transactions
  has_many :account_balances, :dependent => :destroy
  has_many :incoming_transfers, class_name:"Transfer", foreign_key: "to_account_id", :dependent => :destroy
  has_many :outgoing_transfers, class_name:"Transfer", foreign_key: "from_account_id",  :dependent => :destroy

  validates :account_name, presence: true, :uniqueness => {:scope => :user}
  validates :order_in_list, presence: true, numericality: { only_integer: true, greater_than: 0 }, :uniqueness => {:scope => :user}
  validates :user_id, presence: true

  before_destroy :check_no_transactions_or_transfers

  private
    def check_no_transactions_or_transfers
      if self.transactions.count > 0
        self.errors.add(:base, :deletion_status, message: 'Cannot delete an account that is being used for one or more transactions.')
        throw :abort
      elsif self.incoming_transfers.count > 0 or self.outgoing_transfers.count > 0
        self.errors.add(:base, :deletion_status, message: 'Cannot delete an account that is being used for one or more transfers.')
        throw :abort
      end
    end

end
