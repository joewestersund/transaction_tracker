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
    get :show, params: {id: @a1}
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post :create, params: {account: { account_name: "#{@a1.account_name}_test" }}
    end

    assert_redirected_to accounts_path
  end

  test "should get edit" do
    get :edit, params: {id: @a1}
    assert_response :success
  end

  test "should update account" do
    patch :update, params: {id: @a1, account: { account_name: @a1.account_name }}
    assert_redirected_to accounts_path
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete :destroy, params: {id: @account_with_no_transactions}  #can't delete if it has transactions
    end

    assert_redirected_to accounts_path
  end

  test "shouldn't destroy account if it has transctions" do
    assert_no_difference('Account.count') do
      delete :destroy, params: {id: @a1}  #can't delete if it has transactions
    end

    assert_redirected_to accounts_path
  end

  test "should move account up" do
    two = @a2
    initial_position = two.order_in_list
    get :move_up, params: {id: two.id}
    two.reload
    assert_equal(two.order_in_list, initial_position - 1)
    assert_redirected_to accounts_path
  end

  test "should move account down" do
    one = @a1
    initial_position = one.order_in_list
    get :move_down, params: {id: one.id}
    one.reload
    assert_equal(one.order_in_list, initial_position + 1)
    assert_redirected_to accounts_path
  end

  test "shouldn't move first account up" do
    one = @a1
    initial_position = one.order_in_list
    get :move_up, params: {id: one.id}
    one.reload
    assert_equal(one.order_in_list, initial_position)
    assert_redirected_to accounts_path
  end

  test "shouldn't move last account up" do
    last = @account_with_no_transactions
    initial_position = last.order_in_list
    get :move_down, params: {id: last.id}
    last.reload
    assert_equal(last.order_in_list, initial_position)
    assert_redirected_to accounts_path
  end
end
