require 'test_helper'
include SessionsHelper

class TransactionCategoriesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:u1)
    @tc = transaction_categories(:tc1)
    @tc2 = transaction_categories(:tc2)
    @tc_no_transactions = transaction_categories(:tc_no_transactions)

  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transaction_categories)
  end

  test "should show transaction category" do
    get :show, params: {id: @tc}
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transaction_category" do
    assert_difference('TransactionCategory.count') do
      post :create, params: {transaction_category: { name: "#{@tc.name}_test" }}
    end

    assert_redirected_to transaction_categories_path
  end

  test "should get edit" do
    get :edit, params: {id: @tc}
    assert_response :success
  end

  test "should update transaction_category" do
    patch :update, params: {id: @tc, transaction_category: {user_id: @tc.user_id, name: @tc.name, order_in_list: @tc.order_in_list }}
    assert_redirected_to transaction_categories_path
  end

  test "should destroy transaction_category" do
    assert_difference('TransactionCategory.count', -1) do
      delete :destroy, params: {id: @tc_no_transactions}
    end

    assert_redirected_to transaction_categories_path
  end

  test "should move transaction category up" do
    two = @tc2
    initial_position = two.order_in_list
    get :move_up, params: {id: two.id}
    two.reload
    assert_equal(two.order_in_list, initial_position - 1)
    assert_redirected_to transaction_categories_path
  end

  test "should move transaction category down" do
    one = @tc
    initial_position = one.order_in_list
    get :move_down, params: {id: one.id}
    one.reload
    assert_equal(one.order_in_list, initial_position + 1)
    assert_redirected_to transaction_categories_path
  end

  test "shouldn't move first transaction category up" do
    one = @tc
    initial_position = one.order_in_list
    get :move_up, params: {id: one.id}
    one.reload
    assert_equal(one.order_in_list, initial_position)
    assert_redirected_to transaction_categories_path
  end

  test "shouldn't move last transaction category up" do
    last = @tc_no_transactions
    initial_position = last.order_in_list
    get :move_down, params: {id: last.id}
    last.reload
    assert_equal(last.order_in_list, initial_position)
    assert_redirected_to transaction_categories_path
  end

end
