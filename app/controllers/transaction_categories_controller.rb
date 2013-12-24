class TransactionCategoriesController < ApplicationController
  before_action :set_transaction_category, only: [:show, :edit, :update, :destroy]

  # GET /transaction_categories
  # GET /transaction_categories.json
  def index
    @transaction_categories = TransactionCategory.all
  end

  # GET /transaction_categories/1
  # GET /transaction_categories/1.json
  def show
  end

  # GET /transaction_categories/new
  def new
    @transaction_category = TransactionCategory.new
  end

  # GET /transaction_categories/1/edit
  def edit
  end

  # POST /transaction_categories
  # POST /transaction_categories.json
  def create
    @transaction_category = TransactionCategory.new(transaction_category_params)

    respond_to do |format|
      if @transaction_category.save
        format.html { redirect_to @transaction_category, notice: 'Transaction category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @transaction_category }
      else
        format.html { render action: 'new' }
        format.json { render json: @transaction_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transaction_categories/1
  # PATCH/PUT /transaction_categories/1.json
  def update
    respond_to do |format|
      if @transaction_category.update(transaction_category_params)
        format.html { redirect_to @transaction_category, notice: 'Transaction category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @transaction_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_categories/1
  # DELETE /transaction_categories/1.json
  def destroy
    @transaction_category.destroy
    respond_to do |format|
      format.html { redirect_to transaction_categories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction_category
      @transaction_category = TransactionCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_category_params
      params.require(:transaction_category).permit(:user_name, :name, :is_income, :order_in_list)
    end
end
