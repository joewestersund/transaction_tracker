require 'test_helper'
include SessionsHelper

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
end
