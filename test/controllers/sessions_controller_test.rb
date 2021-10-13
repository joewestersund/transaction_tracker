require 'test_helper'
include SessionsHelper
include ApplicationHelper #for get_current_time

class SessionsControllerTest < ActionController::TestCase

  test "should redirect to transactions by default" do
    # update the test user so we know the password

    test_pw = "test_pw"

    user1 = users(:u1)
    user1.password = test_pw
    user1.password_confirmation = test_pw
    user1.save

    sign_out
    # sign in with this user, with no requested_path
    post :create, params: { email: user1.email, password: test_pw, requested_path: '' }

    assert_redirected_to transactions_path
  end

  test "should redirect to requested page" do
    # update the test user so we know the password

    test_pw = "test_pw"

    user1 = users(:u1)
    user1.password = test_pw
    user1.password_confirmation = test_pw
    user1.save

    sign_out

    ### note: I also did this with a System test, which is better when multiple controllers involved.

    # save the current controller, then use the transfers controller
    old_controller = @controller
    @controller = TransfersController.new

    # attempt to get transfers index page
    get :index

    # now, go back to the old controller
    @controller = old_controller

    # check that we got served the login template instead of the transfer template
    assert_template :new   # sessions/new

    post :create, params: { email: user1.email, password: test_pw, requested_path: '/transfers' }

    assert_redirected_to transfers_path
  end

end
