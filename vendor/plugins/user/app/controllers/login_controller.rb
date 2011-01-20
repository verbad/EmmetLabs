class LoginController < ApplicationController
  disable_store_location :show, :create, :destroy
  # ssl_required :new, :show, :create
  filter_parameter_logging :password
  
  def show
    @login = Login.new
  end

  def create
    @login = Login.new(params[:login])
    if @login.save
      log_in!(@login)
      on_successful_create
    else
      on_failed_create
    end
  end

  def destroy
    @login = Login.find_by_id(session[:login_id])
    if @login == nil || @login.destroy
      log_out!
      on_successful_destroy
    end
  end
  
  protected
  def post_logout_path
    home_page_path
  end

  def post_login_path
    home_page_path
  end

  def on_successful_create
    flash[:notice] = "Login successful".customize
    redirect_back post_login_path
  end

  def on_failed_create
    flash.now[:error] = "Login unsuccessful".customize
    render :action => 'show'
  end

  def on_successful_destroy
    flash[:notice] = "You have been logged out".customize
    redirect_to post_logout_path
  end
end
