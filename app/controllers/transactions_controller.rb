class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = current_user.transactions.all
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
    Time.use_zone(current_user.time_zone) do
      @transaction.date = Time.now.in_time_zone
    end
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user = current_user

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transactions_path, notice: 'Transaction was successfully created.' }
        format.json { render action: 'show', status: :created, location: @transaction }
      else
        set_select_options
        format.html { render action: 'new' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to transactions_path, notice: 'Transaction was successfully updated.' }
        format.json { head :no_content }
      else
        set_select_options
        format.html { render action: 'edit' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      t = Transaction.find(params[:id])
      if t.nil? or t.user != current_user
        redirect_to transactions_path
      else
        @transaction = t
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:date, :vendor_name, :account_id, :transaction_category_id, :amount, :description)
    end

    def set_select_options
      @user_accounts = current_user.accounts.order('order_in_list').all
      @user_transaction_categories = current_user.transaction_categories.order('order_in_list').all
    end
end
