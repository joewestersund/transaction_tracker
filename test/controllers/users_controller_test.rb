require 'test_helper'
include SessionsHelper

class UsersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:u1)
    @user = users(:u1)
    @user2 = users(:u2)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, params: {user: { email: "test_#{@user.email}", name: "test", password: "test_pw", password_confirmation: "test_pw" }}
    end

    assert_redirected_to welcome_path
  end

  test "should show user" do
    get :show, params: {id: @user}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @user}
    assert_response :success
  end

  test "should update user" do
    patch :update, params: {id: @user, user: { name: @user.name, email: @user.email, time_zone: @user.time_zone  }}
    assert_response :success
    #assert_redirected_to profile_edit_path
  end

  #test "should destroy user" do
  #  assert_difference('User.count', -1) do
  #    delete :destroy, id: @user2
  #  end

  #  assert_redirected_to users_path
  #end
end
