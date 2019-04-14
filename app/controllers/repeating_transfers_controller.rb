class RepeatingTransfersController < ApplicationController
  before_action :set_repeating_transfer, only: [:show, :edit, :update, :destroy]

  # GET /repeating_transfers
  # GET /repeating_transfers.json
  def index
    @repeating_transfers = RepeatingTransfer.all
  end

  # GET /repeating_transfers/1
  # GET /repeating_transfers/1.json
  def show
  end

  # GET /repeating_transfers/new
  def new
    @repeating_transfer = RepeatingTransfer.new
  end

  # GET /repeating_transfers/1/edit
  def edit
  end

  # POST /repeating_transfers
  # POST /repeating_transfers.json
  def create
    @repeating_transfer = RepeatingTransfer.new(repeating_transfer_params)

    respond_to do |format|
      if @repeating_transfer.save
        format.html { redirect_to @repeating_transfer, notice: 'Repeating transfer was successfully created.' }
        format.json { render :show, status: :created, location: @repeating_transfer }
      else
        format.html { render :new }
        format.json { render json: @repeating_transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repeating_transfers/1
  # PATCH/PUT /repeating_transfers/1.json
  def update
    respond_to do |format|
      if @repeating_transfer.update(repeating_transfer_params)
        format.html { redirect_to @repeating_transfer, notice: 'Repeating transfer was successfully updated.' }
        format.json { render :show, status: :ok, location: @repeating_transfer }
      else
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
      @repeating_transfer = RepeatingTransfer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repeating_transfer_params
      params.require(:repeating_transfer).permit(:user_id, :from_account_id, :to_account_id, :amount, :description, :repeat_start_date, :ends_after_num_occurrences, :ends_after_date, :repeat_period, :repeat_every_x_periods, :repeat_on_x_day_of_period, :last_occurrence_added)
    end
end
