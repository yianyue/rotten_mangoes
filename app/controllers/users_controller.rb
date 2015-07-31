class UsersController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to movies_path
    else
      render :new
    end
  end

  def show
    # find raises an exception when id is invalid. find_by returns nil
    @user = User.find_by(id: params[:id])
    if @user
      @reviews = @user.reviews.includes(:movie)
    else
      redirect_to root_path, notice: "User not found"
    end
  end

  protected

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
  end

end
