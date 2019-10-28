class TransactionsController < ApplicationController
  include RepeatingObjectsHelper
  include ActionController::Live
  require 'csv'

  before_action :signed_in_user
  before_action :set_transaction, only: [:show, :edit, :copy, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit, :copy, :index]
  before_action :check_and_create_repeat_instances, only: :index

  # GET /transactions
  # GET /transactions.json
  def index
    conditions = get_conditions
    t = current_user.transactions.where(conditions).order("transaction_date DESC")

    respond_to do |format|
      format.html {
        @filtered = !conditions[1].empty?
        @transactions = t.page(params[:page]).per_page(20)
      }
      format.xlsx {
        @transactions = t
        response.headers['Content-Disposition'] = 'attachment; filename="transactions.xlsx"'
      }
      format.csv {
        stream_csv(t)
      }
    end

  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
    @transaction.transaction_date = get_current_time
  end

  # GET /transactions/1/edit
  def edit
  end

  def copy
    @transaction = @transaction.dup
    @transaction.transaction_date = get_current_time
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params_without_amount)
    @transaction.amount = currency_string_to_number(transaction_params_amount)
    @transaction.user = current_user
    set_year_month_day(@transaction)

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
      @transaction.attributes = transaction_params_without_amount
      @transaction.amount = currency_string_to_number(transaction_params_amount)
      set_year_month_day(@transaction)
      if @transaction.save
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
      @transaction = current_user.transactions.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params_without_amount
      params.require(:transaction).permit(:transaction_date, :vendor_name, :account_id, :transaction_category_id, :description)
    end

    def transaction_params_amount
      params[:transaction][:amount]
    end


    def set_select_options
      @user_accounts = current_user.accounts.order('order_in_list').all
      @user_transaction_categories = current_user.transaction_categories.order('order_in_list').all
    end

    def set_year_month_day(transaction) #set these ahead of time in the database, so we can index on them and avoid DB-specific SQL in Summaries table.
      transaction.year = transaction.transaction_date.year
      transaction.month = transaction.transaction_date.month
      transaction.day = transaction.transaction_date.day
    end

    def search_params
      params.permit(:month, :day, :year, :vendor_name, :account_id, :transaction_category_id, :amount, :description)
    end

    def get_conditions

      search_terms = Transaction.new(search_params)

      conditions = {}
      conditions_string = []

      conditions[:start_date] = params[:start_date] if params[:start_date].present?
      conditions_string << "transaction_date >= :start_date" if params[:start_date].present?

      conditions[:end_date] = params[:end_date] if params[:end_date].present?
      conditions_string << "transaction_date <= :end_date" if params[:end_date].present?

      conditions[:month] = search_terms.month if search_terms.month.present?
      conditions_string << "month = :month" if search_terms.month.present?

      conditions[:day] = search_terms.day if search_terms.day.present?
      conditions_string << "day = :day" if search_terms.day.present?

      conditions[:year] = search_terms.year if search_terms.year.present?
      conditions_string << "year = :year" if search_terms.year.present?

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

    def stream_csv(transactions)
      set_csv_file_headers
      set_csv_streaming_headers

      response.status = 200

      write_csv_rows(transactions)
    end

    def write_csv_rows(transactions)
      begin
        #write out the header row
        response.stream.write CSV.generate_line(Transaction.csv_header)

        #write out each row of data
        transactions.each do |t|
          response.stream.write CSV.generate_line(t.to_csv)
        end
      ensure
        response.stream.close
      end
    end

end
