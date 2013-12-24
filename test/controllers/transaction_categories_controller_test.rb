require 'test_helper'

class TransactionCategoriesControllerTest < ActionController::TestCase
  setup do
    @transaction_category = transaction_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transaction_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transaction_category" do
    assert_difference('TransactionCategory.count') do
      post :create, transaction_category: { is_income: @transaction_category.is_income, name: @transaction_category.name, order_in_list: @transaction_category.order_in_list, user_name: @transaction_category.user_name }
    end

    assert_redirected_to transaction_category_path(assigns(:transaction_category))
  end

  test "should show transaction_category" do
    get :show, id: @transaction_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transaction_category
    assert_response :success
  end

  test "should update transaction_category" do
    patch :update, id: @transaction_category, transaction_category: { is_income: @transaction_category.is_income, name: @transaction_category.name, order_in_list: @transaction_category.order_in_list, user_name: @transaction_category.user_name }
    assert_redirected_to transaction_category_path(assigns(:transaction_category))
  end

  test "should destroy transaction_category" do
    assert_difference('TransactionCategory.count', -1) do
      delete :destroy, id: @transaction_category
    end

    assert_redirected_to transaction_categories_path
  end
end
