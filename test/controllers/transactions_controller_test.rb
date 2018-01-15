require 'test_helper'
include SessionsHelper

class TransactionsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:u1)
    @transaction = transactions(:t1)
    @account = accounts(:a1)
    @transaction_category = transaction_categories(:tc1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transactions)
  end

  test "should get xlsx" do
    get :index, :format => :xlsx
    assert_response :success
  end

  test "should get csv" do
    skip "not sure how to test streaming response"
    #get :index, :format => :csv
    #assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transaction" do
    assert_difference('Transaction.count') do
      post :create, params: {transaction: { amount: @transaction.amount, transaction_date: @transaction.transaction_date, description: @transaction.description, vendor_name: @transaction.vendor_name, account_id: @account, transaction_category_id: @transaction_category }}
    end

    assert_redirected_to transactions_path
  end

  test "should show transaction" do
    get :show, params: {id: @transaction.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @transaction}
    assert_response :success
  end

  test "should update transaction" do
    patch :update, params: {id: @transaction, transaction: { amount: @transaction.amount, transaction_date: @transaction.transaction_date, description: @transaction.description, vendor_name: @transaction.vendor_name, account_id: @account, transaction_category_id: @transaction_category }}
    assert_redirected_to transactions_path
  end

  test "should destroy transaction" do
    assert_difference('Transaction.count', -1) do
      delete :destroy, params: {id: @transaction}
    end

    assert_redirected_to transactions_path
  end
end
