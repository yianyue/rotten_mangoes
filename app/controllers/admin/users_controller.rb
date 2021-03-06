class Admin::UsersController < Admin::BaseController
  # what about inhereting from UsersController?

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
    @user = User.find_by(id: params[:id])
    if @user
      @reviews = @user.reviews.includes(:movie)
    else
      redirect_to root_path, notice: "User not found"
    end
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
    # Tell the UserMailer to send a delete email
    UserMailer.delete_email(@user).deliver_later
    @user.destroy
    redirect_to admin_users_path
  end

  # QUESTION: is this the right place to put become_user?

  def become_user
    session[:mock_id] = params[:id]
    redirect_to root_url
  end

  protected

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation, :admin)
  end

end