class Admin::AdminController < ApplicationController
  before_filter :login_required
  before_filter :super_admin_required
  
  layout "admin"
end