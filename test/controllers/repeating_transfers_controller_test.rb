require 'test_helper'

class RepeatingTransfersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repeating_transfer = repeating_transfers(:one)
  end

  test "should get index" do
    get repeating_transfers_url
    assert_response :success
  end

  test "should get new" do
    get new_repeating_transfer_url
    assert_response :success
  end

  test "should create repeating_transfer" do
    assert_difference('RepeatingTransfer.count') do
      post repeating_transfers_url, params: { repeating_transfer: { after_date: @repeating_transfer.after_date, amount: @repeating_transfer.amount, description: @repeating_transfer.description, ends: @repeating_transfer.ends, ends_after_num_occurrences: @repeating_transfer.ends_after_num_occurrences, from_account_id: @repeating_transfer.from_account_id, last_occurrence_added: @repeating_transfer.last_occurrence_added, repeat_every_x_periods: @repeating_transfer.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transfer.repeat_on_x_day_of_period, repeat_period: @repeating_transfer.repeat_period, repeat_start_date: @repeating_transfer.repeat_start_date, to_account_id: @repeating_transfer.to_account_id, user_id: @repeating_transfer.user_id } }
    end

    assert_redirected_to repeating_transfer_url(RepeatingTransfer.last)
  end

  test "should show repeating_transfer" do
    get repeating_transfer_url(@repeating_transfer)
    assert_response :success
  end

  test "should get edit" do
    get edit_repeating_transfer_url(@repeating_transfer)
    assert_response :success
  end

  test "should update repeating_transfer" do
    patch repeating_transfer_url(@repeating_transfer), params: { repeating_transfer: { after_date: @repeating_transfer.after_date, amount: @repeating_transfer.amount, description: @repeating_transfer.description, ends: @repeating_transfer.ends, ends_after_num_occurrences: @repeating_transfer.ends_after_num_occurrences, from_account_id: @repeating_transfer.from_account_id, last_occurrence_added: @repeating_transfer.last_occurrence_added, repeat_every_x_periods: @repeating_transfer.repeat_every_x_periods, repeat_on_x_day_of_period: @repeating_transfer.repeat_on_x_day_of_period, repeat_period: @repeating_transfer.repeat_period, repeat_start_date: @repeating_transfer.repeat_start_date, to_account_id: @repeating_transfer.to_account_id, user_id: @repeating_transfer.user_id } }
    assert_redirected_to repeating_transfer_url(@repeating_transfer)
  end

  test "should destroy repeating_transfer" do
    assert_difference('RepeatingTransfer.count', -1) do
      delete repeating_transfer_url(@repeating_transfer)
    end

    assert_redirected_to repeating_transfers_url
  end
end
