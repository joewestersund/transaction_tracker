class AccountBalancesController < ApplicationController
  before_action :signed_in_user
  before_action :set_account_balance, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit, :index]

  # GET /account_balances
  # GET /account_balances.json
  def index
    @account_balances = current_user.account_balances.page(params[:page]).per_page(20).order(:balance_date)
  end

  # GET /account_balances/1
  # GET /account_balances/1.json
  def show
  end

  # GET /account_balances/new
  def new
    if current_user.accounts.count == 0
      #need an account before you can add a balance
      format.html { redirect_to account_balances_path notice: 'You must add an account before you can add an account balance.' }
      format.json { render json: @account_balance.errors, status: :unprocessable_entity }
    else
      @account_balance = AccountBalance.new
      @account_balance.account_id = @user_accounts.first.id
    end
  end

  # GET /account_balances/1/edit
  def edit
  end

  # POST /account_balances
  # POST /account_balances.json
  def create
    @account_balance = AccountBalance.new(account_balance_params)
    @account_balance.user = current_user

    respond_to do |format|
      if @account_balance.save
        format.html { redirect_to account_balances_path, notice: 'Account balance was successfully created.' }
        format.json { render action: 'show', status: :created, location: @account_balance }
      else
        set_select_options
        format.html { render action: 'new' }
        format.json { render json: @account_balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_balances/1
  # PATCH/PUT /account_balances/1.json
  def update
    respond_to do |format|
      if @account_balance.update(account_balance_params)
        format.html { redirect_to account_balances_path, notice: 'Account balance was successfully updated.' }
        format.json { head :no_content }
      else
        set_select_options
        format.html { render action: 'edit' }
        format.json { render json: @account_balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_balances/1
  # DELETE /account_balances/1.json
  def destroy
    @account_balance.destroy
    respond_to do |format|
      format.html { redirect_to account_balances_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_balance
      @account_balance = AccountBalance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_balance_params
      params.require(:account_balance).permit(:account_id, :balance_date, :balance)
    end

    def set_select_options
      @user_accounts = current_user.accounts.order('order_in_list').all
    end
end
