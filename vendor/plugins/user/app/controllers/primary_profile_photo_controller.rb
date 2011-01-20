class PrimaryProfilePhotoController < ApplicationController
  include UserResource

  def update
    @user.profile.primary_photo_id = params[:id]
    if @user.profile.save
      on_successful_update
    else
      on_failed_update
    end
  end

  protected
  def on_successful_update
    redirect_back
  end

  def on_failed_update
    head :forbidden
  end

end
