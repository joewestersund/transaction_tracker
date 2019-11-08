require 'test_helper'
include SessionsHelper
include ApplicationHelper #for get_current_time

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
      post :create, params: { repeating_transaction: { account_id: @account.id, ends_after_date: @repeating_transaction.ends_after_date, amount: @repeating_transaction.amount, description: @repeating_transaction.description, ends_after_num_occurrences: @repeating_transaction.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transaction.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transaction.repeat_on_x_day_of_period, repeat_period: @repeating_transaction.repeat_period, repeat_start_date: @repeating_transaction.repeat_start_date, transaction_category_id: @transaction_category.id, user_id: @repeating_transaction.user_id, vendor_name: @repeating_transaction.vendor_name, end_type: 'num-occurrences', on_weekday: 'Sunday' } }
    end

    assert_redirected_to repeating_transactions_path
  end

  test "should get edit" do
    get :edit, params: {id: @repeating_transaction}
    assert_response :success
  end

  test "should update repeating_transaction" do
    patch :update, params: {id: @repeating_transaction, repeating_transaction: { account_id: @account.id, ends_after_date: @repeating_transaction.ends_after_date, amount: @repeating_transaction.amount, description: @repeating_transaction.description, ends_after_num_occurrences: @repeating_transaction.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transaction.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transaction.repeat_on_x_day_of_period, repeat_period: @repeating_transaction.repeat_period, repeat_start_date: @repeating_transaction.repeat_start_date, transaction_category_id: @transaction_category.id, user_id: @repeating_transaction.user_id, vendor_name: @repeating_transaction.vendor_name, end_type: 'num-occurrences', on_weekday: 'Sunday' } }
    assert_redirected_to repeating_transactions_path
  end

  test "should destroy repeating_transaction" do
    assert_difference('RepeatingTransaction.count', -1) do
      delete :destroy, params: {id: @repeating_transaction}
    end

    assert_redirected_to repeating_transactions_path
  end

  test "should set repeating_transaction next_occurrence for daily repeat" do
    @repeating_transaction = repeating_transactions(:rtransaction_daily_no_end)
    assert_difference('RepeatingTransaction.count') do
      post :create, params: { repeating_transaction: { account_id: @account.id, ends_after_date: @repeating_transaction.ends_after_date, amount: @repeating_transaction.amount, description: @repeating_transaction.description, ends_after_num_occurrences: @repeating_transaction.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transaction.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transaction.repeat_on_x_day_of_period, repeat_period: @repeating_transaction.repeat_period, repeat_start_date: @repeating_transaction.repeat_start_date, transaction_category_id: @transaction_category.id, user_id: @repeating_transaction.user_id, vendor_name: @repeating_transaction.vendor_name, end_type: 'never'} }
    end

    rt = RepeatingTransaction.last
    assert_equal(rt.repeat_start_date, rt.next_occurrence)
  end

  test "should set repeating_transaction next_occurrence for weekly repeat" do
    @repeating_transaction = repeating_transactions(:rtransaction_every_2_weeks_ends_on_date)
    assert_difference('RepeatingTransaction.count') do
      post :create, params: { repeating_transaction: { account_id: @account.id, ends_after_date: @repeating_transaction.ends_after_date, amount: @repeating_transaction.amount, description: @repeating_transaction.description, ends_after_num_occurrences: @repeating_transaction.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transaction.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transaction.repeat_on_x_day_of_period, repeat_period: @repeating_transaction.repeat_period, repeat_start_date: @repeating_transaction.repeat_start_date, transaction_category_id: @transaction_category.id, user_id: @repeating_transaction.user_id, vendor_name: @repeating_transaction.vendor_name, end_type: 'num-occurrences', on_weekday: 'Thursday' } }
    end

    rt = RepeatingTransaction.last
    assert_equal(5, rt.repeat_on_x_day_of_period) # 1 = Sunday, so 5 = Thursday.

    start_date = rt.repeat_start_date
    next_thursday = start_date + ((5 - start_date.wday - 1) % 7)
    assert_equal(next_thursday, rt.next_occurrence)
  end

  test "should set repeating_transaction next_occurrence for monthly repeat" do
    @repeating_transaction = repeating_transactions(:rtransaction_monthly_on_4_5x)
    assert_difference('RepeatingTransaction.count') do
      post :create, params: { repeating_transaction: { account_id: @account.id, ends_after_date: @repeating_transaction.ends_after_date, amount: @repeating_transaction.amount, description: @repeating_transaction.description, ends_after_num_occurrences: @repeating_transaction.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transaction.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transaction.repeat_on_x_day_of_period, repeat_period: @repeating_transaction.repeat_period, repeat_start_date: @repeating_transaction.repeat_start_date, transaction_category_id: @transaction_category.id, user_id: @repeating_transaction.user_id, vendor_name: @repeating_transaction.vendor_name, end_type: 'num-occurrences'} }
    end

    rt = RepeatingTransaction.last
    assert_equal(4, rt.repeat_on_x_day_of_period)

    start_date = rt.repeat_start_date
    if start_date.mday <= rt.repeat_on_x_day_of_period
      next_occurrence = Date.new(start_date.year, start_date.month, rt.repeat_on_x_day_of_period)
    else
      next_occurrence = Date.new(start_date.year, start_date.month + 1, rt.repeat_on_x_day_of_period)
    end

    assert_equal(next_occurrence, rt.next_occurrence)
  end
end
