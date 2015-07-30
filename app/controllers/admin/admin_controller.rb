class Admin::AdminController < ApplicationController

  before_action :admin_access
  # change admin_access check

  # is this the right place to put the methods?
  # move to Admin::UsersController?

  def become_user
    # return unless current_user.admin
    session[:mock_id] = params[:id]
    redirect_to root_url
  end

  # def become_admin
  #   session[:mock_id] = nil
  #   redirect_to root_url
  # end
  # USE logout instead

end