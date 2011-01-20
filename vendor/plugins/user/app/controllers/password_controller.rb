class PasswordController < ApplicationController
  include UserResource

  disable_store_location :edit, :update
  # require_ssl :edit, :update
  filter_parameter_logging :password
  before_filter :login_required, :only => [:edit, :update]

  def edit
  end

  def update
    @user.attributes = params[:user]
    if @user.save
      on_successful_update
    else
      on_failed_update
    end
  end

  protected
  def on_successful_update
    flash[:notice] = 'Password was successfully updated.'.customize
    redirect_to user_profile_url(@user)
  end

  def on_failed_update
    render :action => "edit"
  end
end
