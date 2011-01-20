class ProfilePhotosController < ApplicationController
  include UserResource
  
  def index
    @profile_photos = @user.profile.photos.find(:all)
  end

  def show
    @profile_photo = @user.profile.photos.find(params[:id])
  end

  def create
    @profile_photo = @user.profile.photos.build(:data => params[:profile_photo][:file], :creator => @user)
    if @profile_photo.save
      on_successful_create
    else
      on_failed_create
    end
  end

  def destroy
    association = @user.profile.assets_associations.find_by_asset_id(params[:id])
    if association.destroy
      on_successful_destroy
    else
      on_failed_destroy
    end
  end

  protected
  def on_successful_create
    flash[:notice] = 'Photo was successfully created.'
    redirect_to profile_photos_url(@profile_photo)
  end

  def on_failed_create
    render :action => "new"
  end

  def on_successful_destroy
    redirect_back
  end

  def on_failed_destroy
    head :forbidden
  end
end

