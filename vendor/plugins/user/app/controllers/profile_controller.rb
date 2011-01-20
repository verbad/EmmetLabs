class ProfileController < ApplicationController
  include UserResource

  before_filter :login_required, :only => [:edit, :update]

  def show
    @profile = @user.profile
  end

  def edit
    @profile = @user.profile
  end

  def update
    @profile = @user.profile
    @profile.attributes = params[:profile]
    if @profile.save
      on_successful_update
    else
      on_failed_update
    end
  end

  protected
  def on_successful_update
    flash[:notice] = 'Profile was successfully updated.'.customize
    redirect_to user_profile_url(@user)
  end

  def on_failed_update
    render :action => "edit"
  end
end
