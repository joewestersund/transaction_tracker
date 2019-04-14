class RepeatingTransactionsController < ApplicationController
  before_action :set_repeating_transaction, only: [:show, :edit, :update, :destroy]

  # GET /repeating_transactions
  # GET /repeating_transactions.json
  def index
    @repeating_transactions = RepeatingTransaction.all
  end

  # GET /repeating_transactions/1
  # GET /repeating_transactions/1.json
  def show
  end

  # GET /repeating_transactions/new
  def new
    @repeating_transaction = RepeatingTransaction.new
  end

  # GET /repeating_transactions/1/edit
  def edit
  end

  # POST /repeating_transactions
  # POST /repeating_transactions.json
  def create
    @repeating_transaction = RepeatingTransaction.new(repeating_transaction_params)

    respond_to do |format|
      if @repeating_transaction.save
        format.html { redirect_to @repeating_transaction, notice: 'Repeating transaction was successfully created.' }
        format.json { render :show, status: :created, location: @repeating_transaction }
      else
        format.html { render :new }
        format.json { render json: @repeating_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repeating_transactions/1
  # PATCH/PUT /repeating_transactions/1.json
  def update
    respond_to do |format|
      if @repeating_transaction.update(repeating_transaction_params)
        format.html { redirect_to @repeating_transaction, notice: 'Repeating transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @repeating_transaction }
      else
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
      @repeating_transaction = RepeatingTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repeating_transaction_params
      params.require(:repeating_transaction).permit(:user_id, :vendor_name, :account_id, :transaction_category_id, :amount, :description, :repeat_start_date, :ends_after_num_occurrences, :ends_after_date, :repeat_period, :repeat_every_x_periods, :repeat_on_x_day_of_period, :last_occurrence_added)
    end
end
