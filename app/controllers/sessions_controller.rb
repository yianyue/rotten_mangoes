class SessionsController < ApplicationController
  
  def new
    
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to movies_path, notice: "Hi, #{user.firstname}!"
    else
      flash.now.alert = "Log in failed..."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to movies_path, notice: "So long, fishes!"
  end

end
