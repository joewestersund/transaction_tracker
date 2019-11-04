require 'test_helper'
include SessionsHelper

class RepeatingTransactionsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:u1)
    @repeating_transaction = repeating_transactions(:rtransaction1)
    @account = accounts(:a1)
    @transaction_category = transaction_categories(:tc1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:repeating_transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create repeating_transaction" do
    assert_difference('RepeatingTransaction.count') do
      post :create, params: { repeating_transaction: { account_id: @account.id, ends_after_date: @repeating_transaction.ends_after_date, amount: @repeating_transaction.amount, description: @repeating_transaction.description, ends_after_num_occurrences: @repeating_transaction.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transaction.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transaction.repeat_on_x_day_of_period, repeat_period: @repeating_transaction.repeat_period, repeat_start_date: @repeating_transaction.repeat_start_date, transaction_category_id: @transaction_category.id, user_id: @repeating_transaction.user_id, vendor_name: @repeating_transaction.vendor_name, end_type: 'num-occurrences' } }
    end

    assert_redirected_to repeating_transactions_path
  end

  test "should get edit" do
    get :edit, params: {id: @repeating_transaction}
    assert_response :success
  end

  test "should update repeating_transaction" do
    patch :update, params: {id: @repeating_transaction, repeating_transaction: { account_id: @account.id, ends_after_date: @repeating_transaction.ends_after_date, amount: @repeating_transaction.amount, description: @repeating_transaction.description, ends_after_num_occurrences: @repeating_transaction.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transaction.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transaction.repeat_on_x_day_of_period, repeat_period: @repeating_transaction.repeat_period, repeat_start_date: @repeating_transaction.repeat_start_date, transaction_category_id: @transaction_category.id, user_id: @repeating_transaction.user_id, vendor_name: @repeating_transaction.vendor_name, end_type: 'num-occurrences' } }
    assert_redirected_to repeating_transactions_path
  end

  test "should destroy repeating_transaction" do
    assert_difference('RepeatingTransaction.count', -1) do
      delete :destroy, params: {id: @repeating_transaction}
    end

    assert_redirected_to repeating_transactions_path
  end
end
