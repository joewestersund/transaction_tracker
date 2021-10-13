class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:email].downcase)
    @requested_path = params[:requested_path]
    if user && user.authenticate(params[:password])
      sign_in user
      if @requested_path.nil? or @requested_path.empty?
        redirect_to transactions_path
      else
        redirect_to @requested_path
      end
    else
      flash.now[:error] = "Invalid username / password"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
