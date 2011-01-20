class PasswordResetRequestsController < ApplicationController
  # require_ssl :show, :update
  filter_parameter_logging :password
  disable_store_location :show, :new, :create, :update

  def show
    @token = PasswordResetToken.find_by_param(params[:id])
  end

  def new
    @password_reset_token = PasswordResetToken.new
  end

  def create
    user = User.find_by_email_address(params[:user][:email_address])
    @token = PasswordResetToken.new(:user => user)
    if @token.save
      on_successful_create
    else
      on_failed_create
    end
  end

  def update
    @token = PasswordResetToken.find_by_param(params[:id])
    @token.attributes = params[:token]
    if @token.save
      log_in!(@token.user.logins.create)
      on_successful_update
    else
      on_failed_update
    end
  end
  
  protected
  def post_password_reset_path
    home_page_path
  end

  def on_successful_create
    render :action => :create
  end

  def on_failed_create
    flash.now[:error] = 'There was a problem resetting your password.'.customize
    render :action => :new
  end

  def on_successful_update
    flash[:notice] = 'Your password has been changed'.customize
    redirect_to post_password_reset_path
  end

  def on_failed_update
    render :action => :show
  end
end
