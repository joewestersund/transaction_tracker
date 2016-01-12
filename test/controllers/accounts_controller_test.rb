require 'test_helper'
include SessionsHelper

class AccountsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:u1)
    @a1 = accounts(:a1)
    @a2 = accounts(:a2)
    @account_with_no_transactions = accounts(:account_with_no_transactions)

  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should show account" do
    get :show, id: @a1
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post :create, account: { account_name: "#{@a1.account_name}_test", order_in_list: 4 }
    end

    assert_redirected_to account_path(assigns(:account))
  end

  test "should get edit" do
    get :edit, id: @a1
    assert_response :success
  end

  test "should update account" do
    patch :update, id: @a1, account: { account_name: @a1.account_name }
    assert_redirected_to accounts_path
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete :destroy, id: @account_with_no_transactions  #can't delete if it has transactions
    end

    assert_redirected_to accounts_path
  end

  test "shouldn't destroy account if it has transctions" do
    assert_no_difference('Account.count') do
      delete :destroy, id: @a1  #can't delete if it has transactions
    end

    assert_redirected_to accounts_path
  end

  test "should move account up" do
    two = @a2
    initial_position = two.order_in_list
    get :move_up, id: two.id
    assert_equal(two.order_in_list, initial_position - 1)
    assert_response :success
  end

  test "should move account down" do
    one = @a1
    initial_position = one.order_in_list
    get :move_down, id: one.id
    assert_equal(one.order_in_list, initial_position + 1)
    assert_response :success
  end

  test "shouldn't move first account up" do
    one = @a1
    initial_position = one.order_in_list
    get :move_up, id: one.id
    assert_equal(one.order_in_list, initial_position)
    assert_response :success
  end

  test "shouldn't move last account up" do
    last = @account_with_no_transactions
    initial_position = last.order_in_list
    get :move_down, id: last.id
    assert_equal(last.order_in_list, initial_position)
    assert_response :success
  end
end
