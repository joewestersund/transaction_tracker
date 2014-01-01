class BalanceChecksController < ApplicationController

  def check_balance
    if params[:account_id].present?
      @account = current_user.accounts.find(params[:account_id])
    else
      @account = current_user.accounts.order(:order_in_list).first
    end
    @user_accounts = current_user.accounts.order(:order_in_list).all

    @account_balance_num = 1 #default value
    @account_balance_num = params[:prev_balance].to_i if params[:prev_balance].present?

    if @account.present? and @account.account_balances.count >= @account_balance_num + 1
      balances = @account.account_balances.order("balance_date DESC")

      @show_earlier_link = (@account.account_balances.count > @account_balance_num + 1)
      @show_later_link = (@account_balance_num > 1)

      @end_balance = balances[@account_balance_num-1]
      @start_balance = balances[@account_balance_num]

      end_date = @end_balance.balance_date.end_of_day
      start_date = @start_balance.balance_date.end_of_day

      conditions = ["account_id = :account_id AND transaction_date > :start_date AND transaction_date <= :end_date", {account_id: @account.id, start_date: start_date, end_date: end_date}]
      @transactions = current_user.transactions.where(conditions).page(params[:page]).per_page(20)
      @total_spending = current_user.transactions.where(conditions).sum(:amount)
    else
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: "To run the balance check you need to have at least 1 account set up, with 2 account balances to compare." }
        format.json { render json: @transaction_category.errors, status: :unprocessable_entity }
      end
    end

  end

end
