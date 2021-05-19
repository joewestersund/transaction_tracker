require 'test_helper'
include SessionsHelper
include ApplicationHelper #for get_current_time

class TransactionsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:u1)
    @transaction = transactions(:t1)
    @account = accounts(:a1)
    @transaction_category = transaction_categories(:tc1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transactions)
  end

  test "should get xlsx" do
    get :index, :format => :xlsx
    assert_response :success
  end

  test "should get csv" do
    skip "not sure how to test streaming response"
    #get :index, :format => :csv
    #assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transaction" do
    assert_difference('Transaction.count') do
      post :create, params: {transaction: { amount: @transaction.amount, transaction_date: @transaction.transaction_date, description: @transaction.description, vendor_name: @transaction.vendor_name, account_id: @account, transaction_category_id: @transaction_category }}
    end

    assert_redirected_to transactions_path
  end

  test "should show transaction" do
    get :show, params: {id: @transaction.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @transaction}
    assert_response :success
  end

  test "should get copy" do
    get :copy, params: {id: @transaction}
    assert_response :success
  end

  test "should update transaction" do
    patch :update, params: {id: @transaction, transaction: { amount: @transaction.amount, transaction_date: @transaction.transaction_date, description: @transaction.description, vendor_name: @transaction.vendor_name, account_id: @account, transaction_category_id: @transaction_category }}
    assert_redirected_to transactions_path
  end

  test "should destroy transaction" do
    assert_difference('Transaction.count', -1) do
      delete :destroy, params: {id: @transaction}
    end

    assert_redirected_to transactions_path
  end

  test "repeating transaction should create monthly transactions" do
    @repeating_transaction = repeating_transactions(:rtransaction_monthly_on_4_5x)
    next_occurrence = @repeating_transaction.next_occurrence
    assert_equal(0, Transaction.where(repeating_transaction: @repeating_transaction).count)

    #this should run the code that creates repeating transactions
    get :index

    assert_equal(@repeating_transaction.ends_after_num_occurrences, Transaction.where(repeating_transaction: @repeating_transaction).count)

    Transaction.where(repeating_transaction: @repeating_transaction).each do |t|
      assert_equal(@repeating_transaction.repeat_on_x_day_of_period, t.transaction_date.day)
      assert_equal(next_occurrence, t.transaction_date)
      next_occurrence += 1.month
    end

  end

  test "repeating transaction should create weekly transactions" do
    @repeating_transaction = repeating_transactions(:rtransaction_every_2_weeks_ends_on_date)
    next_occurrence = @repeating_transaction.next_occurrence
    assert_equal(0, Transaction.where(repeating_transaction: @repeating_transaction).count)

    #this should run the code that creates repeating transactions
    get :index

    assert(@repeating_transaction.ends_after_date >= Transaction.where(repeating_transaction: @repeating_transaction).order(:transaction_date).last.transaction_date)

    Transaction.where(repeating_transaction: @repeating_transaction).each do |t|
      #Date.wday is zero on Sunday. repeat_on_x_day_of_period = 1 on Sunday. so add 1 to compare.
      assert_equal(@repeating_transaction.repeat_on_x_day_of_period, t.transaction_date.wday + 1)
      assert_equal(next_occurrence, t.transaction_date)
      next_occurrence += 2.weeks
    end

    @repeating_transaction.reload
    assert_equal(nil, @repeating_transaction.next_occurrence) #should be set to nil

  end

  test "repeating transaction should create daily transactions" do
    @repeating_transaction = repeating_transactions(:rtransaction_daily_no_end)
    next_occurrence = @repeating_transaction.next_occurrence
    assert_equal(0, Transaction.where(repeating_transaction: @repeating_transaction).count)

    #this should run the code that creates repeating transactions
    get :index

    current_date = get_current_time.change(hour: 0)

    assert_equal(next_occurrence, Transaction.where(repeating_transaction: @repeating_transaction).order(:transaction_date).first.transaction_date)
    assert_equal(current_date, Transaction.where(repeating_transaction: @repeating_transaction).order(:transaction_date).last.transaction_date)

    #Transaction.where(repeating_transaction: @repeating_transaction).each do |t|
    Transaction.where(repeating_transaction: @repeating_transaction).order(:transaction_date).each do |t|
      assert_equal(next_occurrence, t.transaction_date)
      next_occurrence += 1.day
    end

    @repeating_transaction.reload #get the updated next_ocurrence from the DB
    assert_equal(current_date + 1.day, @repeating_transaction.next_occurrence)

  end

end
