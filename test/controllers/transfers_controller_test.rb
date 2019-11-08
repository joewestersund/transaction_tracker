require 'test_helper'
include SessionsHelper
include ApplicationHelper #for get_current_time

class TransfersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:u1)
    @transfer = transfers(:t1)
    @from_account = accounts(:a1)
    @to_account = accounts(:a2)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transfers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transfer" do
    assert_difference('Transfer.count') do
      post :create, params: {transfer: { amount: @transfer.amount, transfer_date: @transfer.transfer_date, description: @transfer.description, to_account_id: @to_account, from_account_id: @from_account }}
    end

    assert_redirected_to transfers_path
  end

  test "should show transfer" do
    get :show, params: {id: @transfer.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @transfer}
    assert_response :success
  end

  test "should get copy" do
    get :copy, params: {id: @transfer}
    assert_response :success
  end

  test "should update transfer" do
    patch :update, params: {id: @transfer, transfer: { amount: @transfer.amount, transfer_date: @transfer.transfer_date, description: @transfer.description, to_account_id: @to_account, from_account_id: @from_account }}
    assert_redirected_to transfers_path
  end

  test "should destroy transfer" do
    assert_difference('Transfer.count', -1) do
      delete :destroy, params: {id: @transfer}
    end

    assert_redirected_to transfers_path
  end

  test "repeating transfer should create transfers" do
    @repeating_transfer = repeating_transfers(:rtransfer1)
    assert_equal(0, Transfer.where(repeating_transfer: @repeating_transfer).count)

    #this should run the code that creates repeating transactions
    get :index

    assert_equal(@repeating_transfer.ends_after_num_occurrences, Transfer.where(repeating_transfer: @repeating_transfer).count)

  end

  test "repeating transfer should create monthly transfers" do
    @repeating_transfer = repeating_transfers(:rtransfer_monthly_on_4_5x)
    next_occurrence = @repeating_transfer.next_occurrence
    assert_equal(0, Transfer.where(repeating_transfer: @repeating_transfer).count)

    #this should run the code that creates repeating transfers
    get :index

    assert_equal(@repeating_transfer.ends_after_num_occurrences, Transfer.where(repeating_transfer: @repeating_transfer).count)

    Transfer.where(repeating_transfer: @repeating_transfer).each do |t|
      assert_equal(@repeating_transfer.repeat_on_x_day_of_period, t.transfer_date.day)
      assert_equal(next_occurrence, t.transfer_date)
      next_occurrence += 1.month
    end

  end

  test "repeating transfer should create weekly transfers" do
    @repeating_transfer = repeating_transfers(:rtransfer_every_2_weeks_ends_on_date)
    next_occurrence = @repeating_transfer.next_occurrence
    assert_equal(0, Transfer.where(repeating_transfer: @repeating_transfer).count)

    #this should run the code that creates repeating transactions
    get :index

    assert(@repeating_transfer.ends_after_date >= Transfer.where(repeating_transfer: @repeating_transfer).order(:transfer_date).last.transfer_date)

    Transfer.where(repeating_transfer: @repeating_transfer).each do |t|
      #Date.wday is zero on Sunday. repeat_on_x_day_of_period = 1 on Sunday. so add 1 to compare.
      assert_equal(@repeating_transfer.repeat_on_x_day_of_period, t.transfer_date.wday + 1)
      assert_equal(next_occurrence, t.transfer_date)
      next_occurrence += 2.weeks
    end

    @repeating_transfer.reload
    assert_equal(nil, @repeating_transfer.next_occurrence) #should be set to nil

  end

  test "recurring transfer should create daily transfers" do
    @repeating_transfer = repeating_transfers(:rtransfer_daily_no_end)
    next_occurrence = @repeating_transfer.next_occurrence
    assert_equal(0, Transfer.where(repeating_transfer: @repeating_transfer).count)

    #this should run the code that creates repeating transfers
    get :index

    current_date = get_current_time.change(hour: 0)

    assert_equal(next_occurrence, Transfer.where(repeating_transfer: @repeating_transfer).order(:transfer_date).first.transfer_date)
    assert_equal(current_date, Transfer.where(repeating_transfer: @repeating_transfer).order(:transfer_date).last.transfer_date)

    Transfer.where(repeating_transfer: @repeating_transfer).each do |t|
      assert_equal(next_occurrence, t.transfer_date)
      next_occurrence += 1.day
    end

    @repeating_transfer.reload #get the updated next_ocurrence from the DB
    assert_equal(current_date + 1.day, @repeating_transfer.next_occurrence)

  end

end
