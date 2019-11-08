require 'test_helper'
include SessionsHelper
include ApplicationHelper #for get_current_time

class RepeatingTransfersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:u1)
    @repeating_transfer = repeating_transfers(:rtransfer1)
    @account1 = accounts(:a1)
    @account2 = accounts(:a2)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:repeating_transfers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create repeating_transfer" do
    assert_difference('RepeatingTransfer.count') do
      post :create, params: { repeating_transfer: { ends_after_date: @repeating_transfer.ends_after_date, amount: @repeating_transfer.amount, description: @repeating_transfer.description, ends_after_num_occurrences: @repeating_transfer.ends_after_num_occurrences, from_account_id: @account1.id, last_occurrence_added: @repeating_transfer.last_occurrence_added, repeat_every_x_periods: @repeating_transfer.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transfer.repeat_on_x_day_of_period, repeat_period: @repeating_transfer.repeat_period, repeat_start_date: @repeating_transfer.repeat_start_date, to_account_id: @account2.id, user_id: @repeating_transfer.user_id, end_type: 'num-occurrences' } }
    end

    assert_redirected_to repeating_transfers_path
  end

  test "should get edit" do
    get :edit, params: {id: @repeating_transfer}
    assert_response :success
  end

  test "should update repeating_transfer" do
    patch :update, params: {id: @repeating_transfer, repeating_transfer: { amount: @repeating_transfer.amount, description: @repeating_transfer.description, ends_after_num_occurrences: @repeating_transfer.ends_after_num_occurrences, ends_after_date: @repeating_transfer.ends_after_date,  from_account_id: @account1.id, last_occurrence_added: @repeating_transfer.last_occurrence_added, repeat_every_x_periods: @repeating_transfer.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transfer.repeat_on_x_day_of_period, repeat_period: @repeating_transfer.repeat_period, repeat_start_date: @repeating_transfer.repeat_start_date, to_account_id: @account2.id, user_id: @repeating_transfer.user_id, end_type: 'num-occurrences' } }
    assert_redirected_to repeating_transfers_path
  end

  test "should destroy repeating_transfer" do
    assert_difference('RepeatingTransfer.count', -1) do
      delete :destroy, params: {id: @repeating_transfer}
    end

    assert_redirected_to repeating_transfers_path
  end

  test "should set repeating_transfer next_occurrence for daily repeat" do
    @repeating_transfer = repeating_transfers(:rtransfer_daily_no_end)
    assert_difference('RepeatingTransfer.count') do
      post :create, params: { repeating_transfer: { user_id: @repeating_transfer.user_id, from_account_id: @account1.id, to_account_id: @account2.id, ends_after_date: @repeating_transfer.ends_after_date, amount: @repeating_transfer.amount, description: @repeating_transfer.description, ends_after_num_occurrences: @repeating_transfer.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transfer.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transfer.repeat_on_x_day_of_period, repeat_period: @repeating_transfer.repeat_period, repeat_start_date: @repeating_transfer.repeat_start_date, end_type: 'never'} }
    end

    rt = RepeatingTransfer.last
    assert_equal(rt.repeat_start_date, rt.next_occurrence)
  end

  test "should set repeating_transfer next_occurrence for weekly repeat" do
    @repeating_transfer = repeating_transfers(:rtransfer_every_2_weeks_ends_on_date)
    assert_difference('RepeatingTransfer.count') do
      post :create, params: { repeating_transfer: { user_id: @repeating_transfer.user_id, from_account_id: @account1.id, to_account_id: @account2.id, ends_after_date: @repeating_transfer.ends_after_date, amount: @repeating_transfer.amount, description: @repeating_transfer.description, ends_after_num_occurrences: @repeating_transfer.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transfer.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transfer.repeat_on_x_day_of_period, repeat_period: @repeating_transfer.repeat_period, repeat_start_date: @repeating_transfer.repeat_start_date, end_type: 'num-occurrences', on_weekday: 'Thursday'} }
    end

    rt = RepeatingTransfer.last
    assert_equal(5, rt.repeat_on_x_day_of_period) # 1 = Sunday, so 5 = Thursday.

    start_date = rt.repeat_start_date
    next_thursday = start_date + ((5 - start_date.wday - 1) % 7)
    assert_equal(next_thursday, rt.next_occurrence)
  end

  test "should set repeating_transfer next_occurrence for monthly repeat" do
    @repeating_transfer = repeating_transfers(:rtransfer_monthly_on_4_5x)
    assert_difference('RepeatingTransfer.count') do
      post :create, params: { repeating_transfer: { user_id: @repeating_transfer.user_id, from_account_id: @account1.id, to_account_id: @account2.id, ends_after_date: @repeating_transfer.ends_after_date, amount: @repeating_transfer.amount, description: @repeating_transfer.description, ends_after_num_occurrences: @repeating_transfer.ends_after_num_occurrences, repeat_every_x_periods: @repeating_transfer.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transfer.repeat_on_x_day_of_period, repeat_period: @repeating_transfer.repeat_period, repeat_start_date: @repeating_transfer.repeat_start_date, end_type: 'num-occurrences'} }
    end

    rt = RepeatingTransfer.last
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
