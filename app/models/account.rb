# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  account_name  :string(255)
#  order_in_list :integer
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#

class Account < ActiveRecord::Base

  belongs_to :user
  has_many :transactions
  has_many :account_balances, :dependent => :destroy
  has_many :incoming_transfers, class_name:"Transfer", foreign_key: "to_account_id", :dependent => :destroy
  has_many :outgoing_transfers, class_name:"Transfer", foreign_key: "from_account_id",  :dependent => :destroy

  validates :account_name, presence: true, :uniqueness => {:scope => :user}
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0 }
  validates :user_id, presence: true

  before_destroy :check_no_transactions_or_transfers

  private
    def check_no_transactions_or_transfers
      status = true
      if self.transactions.count > 0
        self.errors[:deletion_status] = 'Cannot delete an account that is being used for one or more transactions.'
        status = false
      elsif self.incoming_transfers.count > 0 or self.outgoing_transfers.count > 0
        self.errors[:deletion_status] = 'Cannot delete an account that is being used for one or more transfers.'
        status = false
      end
      status
    end

end
