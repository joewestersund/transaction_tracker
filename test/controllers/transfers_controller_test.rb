require 'test_helper'
include SessionsHelper

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
      post :create, params: {transfer: { amount: @transfer.amount, transfer_date: @transfer.transfer_date, description: @transfer.description, to_account: @to_account, from_account: @from_account }}
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
    patch :update, params: {id: @transfer, transfer: { amount: @transfer.amount, transfer_date: @transfer.transfer_date, description: @transfer.description, to_account: @to_account, from_account: @from_account }}
    assert_redirected_to transfers_path
  end

  test "should destroy transfer" do
    assert_difference('Transfer.count', -1) do
      delete :destroy, params: {id: @transfer}
    end

    assert_redirected_to transfers_path
  end

  test "recurring transfer should create transfers" do
    @repeating_transfer = repeating_transfers(:rtransfer1)
    assert_equal(0, Transfer.where(repeating_transfer: @repeating_transfer).count)

    #this should run the code that creates repeating transactions
    get :index

    assert_equal(@repeating_transfer.ends_after_num_occurrences, Transfer.where(repeating_transfer: @repeating_transfer).count)

  end

end
