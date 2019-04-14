class RepeatingTransactionsController < ApplicationController

  before_action :signed_in_user
  before_action :set_repeating_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit, :index]

  # GET /repeating_transactions
  # GET /repeating_transactions.json
  def index
    @repeating_transactions = RepeatingTransaction.all
    conditions = get_conditions
    rt = current_user.repeating_transactions.where(conditions).order("last_occurrence_added DESC")
    @filtered = !conditions[1].empty?
    @repeating_transactions = rt.page(params[:page]).per_page(20)

  end

  # GET /repeating_transactions/1
  # GET /repeating_transactions/1.json
  def show
  end

  # GET /repeating_transactions/new
  def new
    @repeating_transaction = RepeatingTransaction.new
    @repeating_transaction.repeat_start_date = get_current_time
  end

  # GET /repeating_transactions/1/edit
  def edit
  end

  # POST /repeating_transactions
  # POST /repeating_transactions.json
  def create
    @repeating_transaction = RepeatingTransaction.new(repeating_transaction_params_no_amount)
    @repeating_transaction.amount = currency_string_to_number(repeating_transaction_params_amount)
    @repeating_transaction.user = current_user

    respond_to do |format|
      if @repeating_transaction.save
        format.html { redirect_to repeating_transactions_path, notice: 'Repeating transaction was successfully created.' }
        format.json { render :show, status: :created, location: @repeating_transaction }
      else
        set_select_options
        format.html { render :new }
        format.json { render json: @repeating_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repeating_transactions/1
  # PATCH/PUT /repeating_transactions/1.json
  def update
    respond_to do |format|
      @repeating_transaction.attributes = repeating_transaction_params_no_amount
      @repeating_transaction.amount = currency_string_to_number(repeating_transaction_params_amount)

      if @repeating_transaction.save
        format.html { redirect_to repeating_transactions_path, notice: 'Repeating transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @repeating_transaction }
      else
        set_select_options
        format.html { render :edit }
        format.json { render json: @repeating_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repeating_transactions/1
  # DELETE /repeating_transactions/1.json
  def destroy
    @repeating_transaction.destroy
    respond_to do |format|
      format.html { redirect_to repeating_transactions_url, notice: 'Repeating transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repeating_transaction
      @repeating_transaction = current_user.repeating_transactions.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repeating_transaction_params_no_amount
      params.require(:repeating_transaction).permit(:user_id, :vendor_name, :account_id, :transaction_category_id, :description, :repeat_start_date, :ends_after_num_occurrences, :ends_after_date, :repeat_period, :repeat_every_x_periods, :repeat_on_x_day_of_period, :last_occurrence_added)
    end

    def repeating_transaction_params_amount
      params[:repeating_transaction][:amount]
    end

    def set_select_options
      @user_accounts = current_user.accounts.order('order_in_list').all
      @user_transaction_categories = current_user.transaction_categories.order('order_in_list').all
    end

    def search_params
      params.permit(:vendor_name, :account_id, :transaction_category_id, :amount, :description)
    end

    def get_conditions

      search_terms = Transaction.new(search_params)

      conditions = {}
      conditions_string = []

      conditions[:vendor_name] = "%#{search_terms.vendor_name}%" if search_terms.vendor_name.present?
      conditions_string << "vendor_name ILIKE :vendor_name" if search_terms.vendor_name.present?

      conditions[:account_id] = search_terms.account_id if search_terms.account_id.present?
      conditions_string << "account_id = :account_id" if search_terms.account_id.present?

      conditions[:transaction_category_id] = search_terms.transaction_category_id if search_terms.transaction_category_id.present?
      conditions_string << "transaction_category_id = :transaction_category_id" if search_terms.transaction_category_id.present?

      conditions[:amount] = search_terms.amount if search_terms.amount.present?
      conditions_string << "amount = :amount" if search_terms.amount.present?

      conditions[:description] = "%#{search_terms.description}%" if search_terms.description.present?
      conditions_string << "description ILIKE :description" if search_terms.description.present?

      return [conditions_string.join(" AND "), conditions]
    end
end
