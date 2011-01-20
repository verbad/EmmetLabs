class PhotosController < ApplicationController
  before_filter :login_required
  before_filter :resolve_photoable

  def index
    respond_to do |wants|
      wants.js do
        render :update do |page|
          page.replace 'photos', :partial => "index", :locals => {:photoable => @photoable} 
        end
      end
    end
  end

  def create
    success = true
    initial_count = @photoable.photos.size
    if !@photoable.update_attributes(params[:photoable])
      success = false
    end
    @photoable.reload
    if @photoable.photos.size == initial_count
      success = false
    end
    if !success
      # TODO: figure out how to pass a photo error through.
      @photo_error_message = 'Invalid image!'
    end
    render :template => 'photos/create', :layout => false
  end

  private

  def resolve_photoable
    photoable_type = params[:type].constantize
    @photoable = photoable_type.find(params[:id])
  end

end
