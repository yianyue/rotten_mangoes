module Admin
  
  class UsersController < ApplicationController

    before_action :admin_access

    def index
      @users = User.page(params[:page]).per(10)
    end
  
    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path
      else
        render :new
      end
    end

    def show
      @user = User.find(params[:id])
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        redirect_to admin_user_path(@user), notice: "User info updated!"
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path
    end

    protected

    def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation, :admin)
    end

  end

end