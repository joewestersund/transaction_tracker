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

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should validate_presence_of :name
  should validate_presence_of :password
  should validate_presence_of :email
  should validate_uniqueness_of(:email).case_insensitive

end
