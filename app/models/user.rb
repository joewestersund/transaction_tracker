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
#  user_group_id   :integer
#  current_mode    :integer
#

class User < ApplicationRecord

  MODES = {
    transactions: 0,
    workouts: 1
  }
  
  has_secure_password #adds authenticate method, etc.

  has_many :accounts, dependent: :destroy
  has_many :account_balances
  has_many :transaction_categories, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :transfers, dependent: :destroy
  has_many :repeating_transactions, dependent: :destroy
  has_many :repeating_transfers, dependent: :destroy

  has_many :workouts, dependent: :destroy
  has_many :routes, dependent: :destroy
  has_many :workout_types, dependent: :destroy
  has_many :workout_routes, dependent: :destroy
  has_many :data_types, dependent: :destroy
  has_many :dropdown_options, dependent: :destroy
  has_many :data_points, dependent: :destroy
  has_many :default_data_points, dependent: :destroy

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

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCr
  end

  def User.hours_to_reset_password
    1
  end

  def User.hours_to_do_first_login
    24
  end

  def User.generate_random_password
    SecureRandom.urlsafe_base64   # by default, a 16 digit string
  end

  def email_address_with_name
    "#{self.name} <#{self.email}>"
  end

  def generate_password_token!
    self.reset_password_token = generate_pw_token
    self.password_reset_sent_at = Time.now.utc
    self.save
  end

  def password_token_valid?
    if (self.created_at + User.hours_to_do_first_login.hours) > Time.now.utc
      #new user gets hours_to_do_first_login to do their password reset
      true
    else
      #established user gets hours_to_reset_password
      (self.password_reset_sent_at + User.hours_to_reset_password.hours) > Time.now.utc
    end
  end

  def switch_mode(mode)
    if mode != self.current_mode
      self.current_mode = mode
      self.save
    end
  end

  private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  def generate_pw_token
    SecureRandom.hex(10)
  end

end
