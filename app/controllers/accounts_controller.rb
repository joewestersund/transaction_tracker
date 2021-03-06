class AccountsController < ApplicationController
  before_action :signed_in_user
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = current_user.accounts.order('order_in_list').all
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit

  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
    @account.user = current_user
    a_max = current_user.accounts.maximum(:order_in_list)
    @account.order_in_list = a_max.nil? ? 1 : a_max + 1

    respond_to do |format|
      if @account.save
        format.html { redirect_to accounts_path, notice: "Account '#{@account.account_name}' was successfully created." }
        format.json { render action: 'show', status: :created, location: @account }
      else
        format.html { render action: 'new' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to accounts_path, notice: "Account '#{@account.account_name}' was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def move_up
    move(true)
  end

  def move_down
    move(false)
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    if @account.destroy
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: "Account '#{@account.account_name}' was successfully deleted." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to accounts_path, alert: "Account '#{@account.account_name}' could not be deleted. Check that it's not being used in any transactions or transfers."}
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      a = Account.find(params[:id])
      if a.nil? or a.user != current_user
        redirect_to accounts_path
      else
        @account = a
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:account_name, :order_in_list)
    end

    def move(up = true)
      a = Account.find(params[:id])

      if a.present?
        a2 = get_adjacent(a,up)
        if a2.present?
          swap_and_save(a, a2)
          respond_to do |format|
            format.html { redirect_to accounts_path }
            format.json { head :no_content }
          end
          return
        end
      end
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: "could not move" }
        format.json { render json: @transaction_category.errors, status: :unprocessable_entity }
      end
    end

    def get_adjacent(current, get_previous = false)
      if get_previous
        current_user.accounts.where("order_in_list < ?",
                                   current.order_in_list).order("order_in_list DESC").first
      else
        current_user.accounts.where("order_in_list > ?", current.order_in_list).order(:order_in_list).first
      end
    end
end
