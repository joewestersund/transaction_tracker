class RepeatingTransfersController < ApplicationController
  include RepeatingObjectsHelper

  before_action :signed_in_user
  before_action :set_repeating_transfer, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit, :index]

  # GET /repeating_transfers
  # GET /repeating_transfers.json
  def index
    conditions = get_conditions
    @filtered = !conditions[1].empty?
    @repeating_transfers = current_user.repeating_transfers.where(conditions).order(:next_occurrence).page(params[:page]).per_page(20)
  end

  # GET /repeating_transfers/new
  def new

    if current_user.accounts.count < 2
      #need an account before you can add a balance
      format.html { redirect_to accounts_path notice: 'You must have at least 2 accounts before you can record a transfer between them.' }
      format.json { render json: @account_balance.errors, status: :unprocessable_entity }
    else
      @repeating_transfer = RepeatingTransfer.new
      @repeating_transfer.from_account_id = current_user.accounts.order(:order_in_list).first
      @repeating_transfer.to_account_id = current_user.accounts.order(:order_in_list).first
      @repeating_transfer.repeat_every_x_periods = 1
      @repeating_transfer.repeat_period = 'month'
    end

  end

  # GET /repeating_transfers/1/edit
  def edit
  end

  # POST /repeating_transfers
  # POST /repeating_transfers.json
  def create

    @repeating_transfer = RepeatingTransfer.new(repeating_transfer_params_no_amount)
    @repeating_transfer.user = current_user
    @repeating_transfer.amount = currency_string_to_number(repeating_transfer_params_amount)
    set_repeat_period(@repeating_transfer, params[:repeating_transfer])
    set_end_type(@repeating_transfer, params[:repeating_transfer])

    @repeating_transfer.next_occurrence = @repeating_transfer.repeat_start_date

    respond_to do |format|
      if @repeating_transfer.save
        format.html { redirect_to repeating_transfers_path, notice: 'Repeating transfer was successfully created.' }
        format.json { render :show, status: :created, location: @repeating_transfer }
      else
        set_select_options
        format.html { render :new }
        format.json { render json: @repeating_transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repeating_transfers/1
  # PATCH/PUT /repeating_transfers/1.json
  def update
    respond_to do |format|
      @repeating_transfer.attributes = repeating_transfer_params_no_amount
      @repeating_transfer.amount = currency_string_to_number(repeating_transfer_params_amount)
      set_repeat_period(@repeating_transfer, params[:repeating_transfer])
      set_end_type(@repeating_transfer, params[:repeating_transfer])

      reinitialize_next_occurrence(@repeating_transfer)

      if @repeating_transfer.save
        format.html { redirect_to repeating_transfers_path, notice: 'Repeating transfer was successfully updated.' }
        format.json { render :show, status: :ok, location: @repeating_transfer }
      else
        set_select_options
        format.html { render :edit }
        format.json { render json: @repeating_transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repeating_transfers/1
  # DELETE /repeating_transfers/1.json
  def destroy
    @repeating_transfer.destroy
    respond_to do |format|
      format.html { redirect_to repeating_transfers_url, notice: 'Repeating transfer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repeating_transfer
      @repeating_transfer = current_user.repeating_transfers.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repeating_transfer_params_no_amount
      params.require(:repeating_transfer).permit(:from_account_id, :to_account_id, :description, :repeat_start_date, :ends_after_num_occurrences, :ends_after_date, :repeat_period, :repeat_every_x_periods, :last_occurrence_added)
    end

    def repeating_transfer_params_amount
      params[:repeating_transfer][:amount]
    end

    def set_select_options
      @user_accounts = current_user.accounts.order('order_in_list').all
    end

    def search_params
      params.permit(:from_account_id, :to_account_id, :amount, :description)
    end

    def get_conditions

      search_terms = RepeatingTransfer.new(search_params)

      conditions = {}
      conditions_string = []

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
