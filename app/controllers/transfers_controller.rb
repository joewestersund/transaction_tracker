class TransfersController < ApplicationController
  before_action :signed_in_user
  before_action :set_transfer, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit, :index]

  # GET /transfers
  # GET /transfers.json
  def index
    @transfers = current_user.transfers.where(get_conditions).order("transfer_date DESC").page(params[:page]).per_page(20)
  end

  # GET /transfers/1
  # GET /transfers/1.json
  def show
  end

  # GET /transfers/new
  def new
    if current_user.accounts.count < 2
      #need an account before you can add a balance
      format.html { redirect_to account_balances_path notice: 'You must have at least 2 accounts before you can record a transfer between them.' }
      format.json { render json: @account_balance.errors, status: :unprocessable_entity }
    else
      @transfer = Transfer.new
      @transfer.from_account_id = current_user.accounts.order(:order_in_list).first
      @transfer.to_account_id = current_user.accounts.order(:order_in_list).first
    end
  end

  # GET /transfers/1/edit
  def edit
  end

  # POST /transfers
  # POST /transfers.json
  def create
    @transfer = Transfer.new(transfer_params_no_amount)
    @transfer.user = current_user
    @transfer.amount = currency_string_to_number(transfer_params_amount)
    set_year_month_day(@transfer)
    respond_to do |format|
      if @transfer.save
        format.html { redirect_to transfers_path, notice: 'Transfer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @transfer }
      else
        set_select_options
        format.html { render action: 'new' }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transfers/1
  # PATCH/PUT /transfers/1.json
  def update
    respond_to do |format|
      @transfer.attributes = transfer_params_no_amount
      @transfer.amount = currency_string_to_number(transfer_params_amount)
      set_year_month_day(@transfer)
      if @transfer.save
        format.html { redirect_to transfers_path, notice: 'Transfer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfers/1
  # DELETE /transfers/1.json
  def destroy
    @transfer.destroy
    respond_to do |format|
      format.html { redirect_to transfers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_params_no_amount
      params.require(:transfer).permit(:from_account_id, :to_account_id, :transfer_date, :description)
    end

    def transfer_params_amount
      params[:transfer][:amount]
    end

    def set_select_options
      @user_accounts = current_user.accounts.order('order_in_list').all
    end

    def search_params
      params.permit(:month, :day, :year, :from_account_id, :to_account_id, :amount, :description)
    end

    def set_year_month_day(transfer) #set these ahead of time in the database, so we can index on them and avoid DB-specific SQL in Summaries table.
      transfer.year = transfer.transfer_date.year
      transfer.month = transfer.transfer_date.month
      transfer.day = transfer.transfer_date.day
    end

    def get_conditions

      search_terms = Transfer.new(search_params)

      conditions = {}
      conditions_string = []

      conditions[:month] = search_terms.month if search_terms.month.present?
      conditions_string << "month = :month" if search_terms.month.present?

      conditions[:day] = search_terms.day if search_terms.day.present?
      conditions_string << "day = :day" if search_terms.day.present?

      conditions[:year] = search_terms.year if search_terms.year.present?
      conditions_string << "year = :year" if search_terms.year.present?

      conditions[:from_account_id] = search_terms.from_account_id if search_terms.from_account_id.present?
      conditions_string << "from_account_id = :from_account_id" if search_terms.from_account_id.present?

      conditions[:to_account_id] = search_terms.to_account_id if search_terms.to_account_id.present?
      conditions_string << "to_account_id = :to_account_id" if search_terms.to_account_id.present?

      conditions[:amount] = search_terms.amount if search_terms.amount.present?
      conditions_string << "amount = :amount" if search_terms.amount.present?

      conditions[:description] = "%#{search_terms.description}%" if search_terms.description.present?
      conditions_string << "description ILIKE :description" if search_terms.description.present?

      return [conditions_string.join(" AND "), conditions]
    end
end
