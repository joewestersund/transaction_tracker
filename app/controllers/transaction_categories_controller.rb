class TransactionCategoriesController < ApplicationController
  before_action :signed_in_user
  before_action :set_transaction_category, only: [:show, :edit, :update, :destroy]

  # GET /transaction_categories
  # GET /transaction_categories.json
  def index
    @transaction_categories = current_user.transaction_categories.order('order_in_list').all
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
    @transaction_category.user = current_user
    tc_max = current_user.transaction_categories.maximum(:order_in_list)
    @transaction_category.order_in_list = tc_max.nil? ? 1 : tc_max + 1

    respond_to do |format|
      if @transaction_category.save
        format.html { redirect_to transaction_categories_path, notice: "Transaction category '#{@transaction_category.name}' was successfully created." }
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
        format.html { redirect_to transaction_categories_path, notice: "Transaction category '#{@transaction_category.name}' was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @transaction_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def move_up
    move(true)
  end

  def move_down
    move(false)
  end

  # DELETE /transaction_categories/1
  # DELETE /transaction_categories/1.json
  def destroy
    if @transaction_category.destroy
      respond_to do |format|
        format.html { redirect_to transaction_categories_path, notice: "Transaction category '#{@transaction_category.name}' was successfully deleted." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to transaction_categories_path, alert: "Transaction category '#{@transaction_category.name}' could not be deleted. Check that it's not being used for any existing transactions." }
        format.json { render json: @transaction_category.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction_category
      tc = TransactionCategory.find(params[:id])
      if tc.nil? or tc.user != current_user
        redirect_to transaction_categories_path
      else
        @transaction_category = tc
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_category_params
      params.require(:transaction_category).permit(:name, :is_income, :order_in_list)
    end

    def move(up = true)
      tc = TransactionCategory.find(params[:id])

      if tc.present?
        tc2 = get_adjacent(tc,up)
        if tc2.present?
          swap_and_save(tc, tc2)
          respond_to do |format|
            format.html { redirect_to transaction_categories_path }
            format.json { head :no_content }
          end
          return
        end
      end
      respond_to do |format|
        format.html { redirect_to transaction_categories_path, notice: "could not move" }
        format.json { render json: @transaction_category.errors, status: :unprocessable_entity }
      end
    end

    def get_adjacent(current, get_previous = false)
      if get_previous
        current_user.transaction_categories.where("order_in_list < ?",
                                                  current.order_in_list).order("order_in_list DESC").first
      else
        current_user.transaction_categories.where("order_in_list > ?",
                                                  current.order_in_list).order(:order_in_list).first
      end
    end

end
