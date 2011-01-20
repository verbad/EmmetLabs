class PhotoCommentsController < ApplicationController
  before_filter :login_required
  before_filter :resolve_photo

  def create
    @photo.comments.create(:author => current_user, :text => params[:comment][:text])
    @comment = @photo.comments.last
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update_attributes(params[:comment])
  end

  private

  def resolve_photo
    @photo = Photo.find(params[:photo_id])
  end

end
