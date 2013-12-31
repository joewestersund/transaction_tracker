class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :edit_password, :update, :update_password, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params_new)
    if @user.save
      create_user_defaults(@user)
      sign_in @user
      flash[:notice] = "Welcome to the Transaction Tracker!"
      redirect_to welcome_path
    else
      render 'new'
    end
  end

  def edit
  end

  def edit_password
  end

  def update
    params[:user].delete(:password) #don't update the password here.
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to profile_edit_path, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def update_password
    respond_to do |format|
      if params[:user][:password].present? and @user.update(user_params_change_password)
        format.html { redirect_to profile_edit_password_path, notice: 'Your password was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit_password' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    sign_out
    @user.destroy
    respond_to do |format|
      format.html { redirect_to signup_path }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:name, :email, :time_zone)
    end

    def user_params_new
      params.require(:user).permit(:name, :email, :time_zone, :password, :password_confirmation)
    end

    def user_params_change_password()
      params.require(:user).permit(:password, :password_confirmation)
    end

    def create_user_defaults(user)
      ["cash" "checking" "savings" "credit card"].each do |account_name|
        a = Account.new
        a.account_name = "cash"
        a.user = user
        a.save
      end

      ["rent" "groceries" "restauraunts" "car" "salary"].each do |cat_name|
        tc = TransactionCategory.new
        tc.name = cat_name
        tc.user = user
        tc.save
      end
    end

end
