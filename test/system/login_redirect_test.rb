require "application_system_test_case"

class LoginRedirectTest < ApplicationSystemTestCase
  test "should default to transactions after login" do
    test_pw = "test_pw"

    user1 = users(:u1)
    user1.password = test_pw
    user1.password_confirmation = test_pw
    user1.save

    visit signin_path

    assert_text "Sign in"

    fill_in "email", with: user1.email
    fill_in "password", with: test_pw

    click_on "Sign in"

    assert_text "Transactions"
  end

  test "should redirect after login" do
    test_pw = "test_pw"

    user1 = users(:u1)
    user1.password = test_pw
    user1.password_confirmation = test_pw
    user1.save

    visit transfers_path

    assert_text "Sign in"   #"Please sign in"

    fill_in "email", with: user1.email
    fill_in "password", with: test_pw

    click_on "Sign in"

    assert_text "Transfers"
  end
end
