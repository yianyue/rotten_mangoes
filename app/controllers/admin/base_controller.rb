class Admin::BaseController < ApplicationController
  
  before_action :admin_access 
  
end