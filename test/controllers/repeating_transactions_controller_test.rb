require 'test_helper'

class RepeatingTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repeating_transaction = repeating_transactions(:one)
  end

  test "should get index" do
    get repeating_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_repeating_transaction_url
    assert_response :success
  end

  test "should create repeating_transaction" do
    assert_difference('RepeatingTransaction.count') do
      post repeating_transactions_url, params: { repeating_transaction: { account_id: @repeating_transaction.account_id, after_date: @repeating_transaction.after_date, amount: @repeating_transaction.amount, description: @repeating_transaction.description, ends: @repeating_transaction.ends, ends_after_num_occurrences: @repeating_transaction.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transaction.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transaction.repeat_on_x_day_of_period, repeat_period: @repeating_transaction.repeat_period, repeat_start_date: @repeating_transaction.repeat_start_date, transaction_category_id: @repeating_transaction.transaction_category_id, user_id: @repeating_transaction.user_id, vendor_name: @repeating_transaction.vendor_name } }
    end

    assert_redirected_to repeating_transaction_url(RepeatingTransaction.last)
  end

  test "should show repeating_transaction" do
    get repeating_transaction_url(@repeating_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_repeating_transaction_url(@repeating_transaction)
    assert_response :success
  end

  test "should update repeating_transaction" do
    patch repeating_transaction_url(@repeating_transaction), params: { repeating_transaction: { account_id: @repeating_transaction.account_id, after_date: @repeating_transaction.after_date, amount: @repeating_transaction.amount, description: @repeating_transaction.description, ends: @repeating_transaction.ends, ends_after_num_occurrences: @repeating_transaction.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transaction.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transaction.repeat_on_x_day_of_period, repeat_period: @repeating_transaction.repeat_period, repeat_start_date: @repeating_transaction.repeat_start_date, transaction_category_id: @repeating_transaction.transaction_category_id, user_id: @repeating_transaction.user_id, vendor_name: @repeating_transaction.vendor_name } }
    assert_redirected_to repeating_transaction_url(@repeating_transaction)
  end

  test "should destroy repeating_transaction" do
    assert_difference('RepeatingTransaction.count', -1) do
      delete repeating_transaction_url(@repeating_transaction)
    end

    assert_redirected_to repeating_transactions_url
  end
end
