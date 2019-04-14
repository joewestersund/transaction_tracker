# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  created_at      :datetime
#  updated_at      :datetime
#  name            :string
#  password_digest :string
#  remember_token  :string
#  time_zone       :string
#

class User < ApplicationRecord
  has_secure_password #adds authenticate method, etc.

  has_many :accounts, :dependent => :destroy
  has_many :account_balances
  has_many :transaction_categories, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  has_many :transfers, :dependent => :destroy
  has_many :repeating_transactions, :dependent => :destroy
  has_many :repeating_transfers, :dependent => :destroy

  before_save { |user| user.email.downcase! }
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100}, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}

  validates :password, :presence =>true, :confirmation => true, :length => { :within => 6..40 }, :on => :create
  validates :password, :confirmation => true, :length => { :within => 6..40 }, :on => :update_password


  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

end
