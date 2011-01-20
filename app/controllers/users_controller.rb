class UsersController < ApplicationController
  #before_filter :super_admin_required, :except => [:edit, :update]
  def on_successful_create
    flash[:notice] = 'Your account has been created.'.customize
    redirect_to new_email_address_verification_request_path(@user, @user.primary_email_address)
  end
  
  def on_failed_create
    @hideHeader = true;
    render :template => 'login/show'
  end
  
end 