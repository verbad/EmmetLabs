class PasswordResetRequestsController < ApplicationController
  def new
    @token = PasswordResetToken.new
    render :template => 'password_reset_requests/new.html.haml'    
  end

  def on_failed_create
    render :template => 'password_reset_requests/new.html.haml'
  end

  def on_failed_update
    render :template => 'password_reset_requests/show.html.haml'
  end

  def on_successful_update
    redirect_to post_password_reset_path
  end

end
