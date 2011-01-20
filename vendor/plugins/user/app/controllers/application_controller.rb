class ApplicationController < ActionController::Base
  include SslRequirement, StoreLocation
  
  before_filter :prevent_access_by_disabled_users
  around_filter :inhibit_retardase
  helper :users
  
  private
  def prevent_access_by_disabled_users
    if !current_user.nil? && current_user.disabled?
      log_out!
      redirect_to login_path unless params[:controller] == 'login'
    end
  end
end