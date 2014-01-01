class BalanceChecksController < ApplicationController

  def check_balance
    #only include accounts that have enough balance info to do a check
    @user_accounts = []
    current_user.accounts.order(:order_in_list).each do |a|
      if a.account_balances.count >= 2
        @user_accounts << a
        break
      end
    end

    @account_balance_num = 1 #default value

    if params[:account_id].present?
      a = current_user.accounts.find(params[:account_id])
      if a.present?
        @account = a
        @account_balance_num = params[:prev_balance].to_i if params[:prev_balance].present?
      end
    else
      @account = @user_accounts[0] if @user_accounts.count > 0
    end

    if @account.present? and @account.account_balances.count >= @account_balance_num + 1
      balances = @account.account_balances.order("balance_date DESC")

      @show_earlier_link = (@account.account_balances.count > @account_balance_num + 1)
      @show_later_link = (@account_balance_num > 1)

      @end_balance = balances[@account_balance_num-1]
      @start_balance = balances[@account_balance_num]

      end_date = @end_balance.balance_date.end_of_day
      start_date = @start_balance.balance_date.end_of_day
      transaction_conditions = get_conditions(:transactions, @account.id, start_date, end_date)
      transfer_in_conditions = get_conditions(:transfers_in, @account.id, start_date, end_date)
      transfer_out_conditions = get_conditions(:transfers_out, @account.id, start_date, end_date)

      @transactions = current_user.transactions.where(transaction_conditions).order("transaction_date DESC").page(params[:transactions_page]).per_page(10)
      @total_spending = current_user.transactions.where(transaction_conditions).sum(:amount)
      @transfers_in = @account.incoming_transfers.where(transfer_in_conditions).order("transfer_date DESC").page(params[:transfers_in_page]).per_page(10)
      @transfers_out = @account.outgoing_transfers.where(transfer_out_conditions).order("transfer_date DESC").page(params[:transfers_out_page]).per_page(10)
      @transfers_in_total = @account.incoming_transfers.where(transfer_in_conditions).sum(:amount)
      @transfers_out_total = @account.outgoing_transfers.where(transfer_out_conditions).sum(:amount)

    else
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: "To run the balance check you need to have at least 1 account set up, with 2 account balances to compare." }
        format.json { render json: @transaction_category.errors, status: :unprocessable_entity }
      end
    end

  end

  private

  def get_conditions(type, account_id, start_date, end_date)
    if type == :transactions
      ["account_id = :account_id AND transaction_date > :start_date AND transaction_date <= :end_date", {account_id: account_id, start_date: start_date, end_date: end_date}]
    elsif type == :transfers_in
      ["transfer_date > :start_date AND transfer_date <= :end_date", {start_date: start_date, end_date: end_date}]
    elsif type == :transfers_out
      ["transfer_date > :start_date AND transfer_date <= :end_date", {start_date: start_date, end_date: end_date}]
    else
      raise "Error: type not recognized in get_conditions()"
    end

  end

end
