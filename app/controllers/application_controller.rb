class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def restrict_access
    if !current_user
      flash[:alert] = "You must log in."
      redirect_to new_session_path
    end
  end

  def admin_access
    # TODO: refactor this
    unless (current_user && current_user.admin) || mock_user
      flash[:alert] = "You must be an admin to access this page"
      redirect_to new_session_path
    end
  end

  protected

  def current_user
    return mock_user if mock_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def mock_user
    # find_by returns nil when id does not exist
    @mock_user ||= User.find_by(id: session[:mock_id]) if session[:mock_id]     
  end

  helper_method :current_user, :mock_user
  
end
