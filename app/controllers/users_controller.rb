class UsersController < ApplicationController
  include ActionView::Helpers::TextHelper  # for pluralize method

  before_action :signed_in_user, only: [:edit_profile, :update, :destroy ]
  before_action :signed_in_user_unactivated_ok, only: [ :edit_password, :update_password ]
  before_action :set_self_as_user, only: %i[ edit_profile update update_profile edit_password update_password destroy ]


  # GET /users/new
  def new
    @user = User.new
  end

  def activate
  end

  def create
    if (verify_recaptcha(model: @user) || Rails.env == "development")
      @user = User.new(user_params_new)

      #create a temporary password. We won't tell them what it is, but it will prevent anyone from logging into this account until they create one
      pw = User.generate_random_password
      @user.password = pw
      @user.password_confirmation = pw

      if @user.save

        sign_in @user

        @user.generate_password_token!
        NotificationMailer.new_user_email(@user).deliver

        notice_text = "We've sent an email to you at #{@user.email}. Please use the link in that email to set your password and activate your account."

        redirect_to activate_path, notice: notice_text
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  def edit_profile
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

  def update_password
    respond_to do |format|
      if params[:user][:password].present? and @user.update(user_params_change_password)
        if !@user.activated?
          # this user just created their password for the first time
          notice_text = "Welcome to Log My Workout!"
          create_user_defaults(@user)
          flash[:notice] =
            @user.activated = true
          @user.save
        else
          notice_text = 'Your password was successfully updated.'
        end

        format.html { redirect_to workouts_path, notice: notice_text }
        format.json { head :no_content }
      else
        format.html { render action: 'edit_password' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def forgot_password
  end

  def send_password_reset_email
    @user = User.find_by(email: params[:email])
    if @user.present? && (verify_recaptcha(model: @user) || Rails.env == "development")
      @user.generate_password_token!
      NotificationMailer.password_reset_email(@user).deliver
      redirect_to signin_path, notice: "A password reset email has been sent to #{@user.name} at #{@user.email}. Please use the link in that email to reset your password in the next #{pluralize(User.hours_to_reset_password,"hour")}."
    else
      redirect_to password_forgot_path, alert: "That email address was not recognized, or the recaptcha was not recognized."
    end
  end

  def resend_activation_email
    @user = User.find_by(email: params[:email])
    if @user.present? && (verify_recaptcha(model: @user) || Rails.env == "development")

      @user.generate_password_token!
      NotificationMailer.new_user_email(@user).deliver

      notice_text = "We've sent an email to you at #{@user.email}. Please use the link in that email to set your password and activate your account."

      redirect_to activate_path, notice: notice_text
    end
  end

  def reset_password
    @user = User.find_by(reset_password_token: params[:token]) if !params[:token].blank?
    if @user.present? && @user.password_token_valid? then
      sign_in @user

      #erase the password reset token, so they can't reset it again with that same link
      @user.reset_password_token = nil
      @user.save

      if @user.activated?
        notice_text = "Please enter a new password"
      else
        # this user will just be creating their password for the first time
        notice_text = "Please enter a password"
      end

      flash[:notice] = notice_text
      render :edit_password
    else
      flash[:alert] = "That email address was not recognized, or its password reset link has expired."
      redirect_to password_forgot_path
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_self_as_user
      @user = self.current_user
    end

    # Only allow a list of trusted parameters through.
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
      create_user_defaults_for_transactions(user)
      create_user_defaults_for_workouts(user)
    end

    def create_user_defaults_for_transactions(user)
      account_names = ["cash", "checking", "savings", "credit card"]
      account_names.each_with_index do |account_name, index|
        a = Account.new
        a.account_name = account_name
        a.order_in_list = index + 1
        a.user = user
        if !a.save
          respond_to do |format|
            format.html { redirect_to signup_path }
            format.json { head :no_content }
          end
        end
      end

      category_names = ["rent", "groceries", "restaurants", "car", "salary"]
      category_names.each_with_index do |cat_name, index|
        tc = TransactionCategory.new
        tc.name = cat_name
        tc.order_in_list = index + 1
        tc.user = user
        if !tc.save
          respond_to do |format|
            format.html { redirect_to signup_path }
            format.json { head :no_content }
          end
        end
      end
    end

    def create_user_defaults_for_workouts(user)
      wt = user.workout_types.create!(name: "running", order_in_list: 1)
      dt = wt.data_types.create!(user: user, name: "distance", units: "miles", field_type: DataType.field_types_hash[:numeric], order_in_list: 1)
      dt = wt.data_types.create!(user: user, name: "pace", units: "", field_type: DataType.field_types_hash[:minutes_seconds], order_in_list: 2)
      dt = wt.data_types.create!(user: user, name: "hr", units: "bpm", field_type: DataType.field_types_hash[:numeric], order_in_list: 3)
      dt = wt.data_types.create!(user: user, name: "surface", field_type: DataType.field_types_hash[:dropdown], order_in_list: 4)
      dt.dropdown_options.create!(user: user, name: "road", order_in_list: 1)
      dt.dropdown_options.create!(user: user, name: "trail", order_in_list: 2)
      dt = wt.data_types.create!(user: user, name: "notes", field_type: DataType.field_types_hash[:text], order_in_list: 5)

      wt = user.workout_types.create!(name: "bouldering", order_in_list: 2)
      dt = wt.data_types.create!(user: user, name: "notes", field_type: DataType.field_types_hash[:text], order_in_list: 1)
      #wt.routes.create!(user: user, name: "V0", order_in_list: 1)
      #wt.routes.create!(user: user, name: "V1", order_in_list: 2)
      #wt.routes.create!(user: user, name: "V2", order_in_list: 3)
      #wt.routes.create!(user: user, name: "V3", order_in_list: 4)
      #wt.routes.create!(user: user, name: "V4", order_in_list: 5)

      wt = user.workout_types.create!(name: "climbing", order_in_list: 3)
      dt = wt.data_types.create!(user: user, name: "grade", field_type: DataType.field_types_hash[:dropdown], order_in_list: 1)
      dt.dropdown_options.create!(user: user, name: "5.5", order_in_list: 1)
      dt.dropdown_options.create!(user: user, name: "5.6", order_in_list: 2)
      dt.dropdown_options.create!(user: user, name: "5.7", order_in_list: 3)
      dt.dropdown_options.create!(user: user, name: "5.8", order_in_list: 4)
      dt.dropdown_options.create!(user: user, name: "5.9", order_in_list: 5)
      dt.dropdown_options.create!(user: user, name: "5.10-", order_in_list: 6)
      dt.dropdown_options.create!(user: user, name: "5.10", order_in_list: 7)
      dt.dropdown_options.create!(user: user, name: "5.10+", order_in_list: 8)
      dt.dropdown_options.create!(user: user, name: "5.11-", order_in_list: 9)
      dt.dropdown_options.create!(user: user, name: "5.11", order_in_list: 10)
      dt.dropdown_options.create!(user: user, name: "5.11+", order_in_list: 11)
      dt = wt.data_types.create!(user: user, name: "style", field_type: DataType.field_types_hash[:dropdown], order_in_list: 2)
      dt.dropdown_options.create!(user: user, name: "toprope", order_in_list: 1)
      dt.dropdown_options.create!(user: user, name: "lead", order_in_list: 2)
      dt = wt.data_types.create!(user: user, name: "notes", field_type: DataType.field_types_hash[:text], order_in_list: 3)

    end
end