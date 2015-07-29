class AdminController < ApplicationController
  before_action :admin_access

  def become_user
    return unless current_user.admin
    session[:mock_id] = params[:id]
    redirect_to root_url # or user_root_url
  end

end