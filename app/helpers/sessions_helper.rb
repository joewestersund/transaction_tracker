module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def signed_in_user_unactivated_ok
    redirect_to signin_path, notice: "Please sign in." unless signed_in?
  end

  def signed_in_user
    if signed_in?
      redirect_to activate_path, notice: "Please check your email for your activation link." unless current_user.activated?
    else
      redirect_to signin_path, notice: "Please sign in."
    end
    #unless signed_in?
    #  @requested_path = request.path
    #  flash[:notice] = "Please sign in"
    #  render 'sessions/new'
    #end
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def mode_name(mode_number)
    if mode_number == User::MODES[:transactions]
      "Transactions"
    else
      "Workouts"
    end
  end
end
