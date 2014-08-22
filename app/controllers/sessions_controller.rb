class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      # user submitted valid password
      session[:user_id] = user.id
      redirect_to root_path, notice: "Welcome back #{user.first_name}"
    else
      flash[:error] = "Oops, something went wrong. Try again."
      render :login
    end
  end

  def destroy
    user = current_user
    session[:user_id] = nil
    redirect_to root_path,
      notice: "See you next time #{user.email}"
  end
end
