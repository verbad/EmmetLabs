require File.dirname(__FILE__) + '/../spec_helper'

describe ProfilePhotosController, "#create" do
  controller_name :profile_photos

  it "should create a new photo" do
    user = users(:valid_bob)
    photo_count = user.profile.photos.size
    photo = fixture_file_upload('/test.gif', 'image/gif')
    post :create, :user_id => user.to_param, :profile_photo => {:file => photo}
    user.reload
    user.profile.photos.size.should be == photo_count + 1
  end

end

describe ProfilePhotosController, "#delete" do
  controller_name :profile_photos

  it "should delete the selected photo" do
    user = users(:valid_bob)
    log_in(user)
    photo = assets(:basic_1)
    photo_count = user.profile.photos.size
    delete :destroy, :user_id => user.to_param, :id => photo.id
    user.reload
    user.profile.photos.size.should be == photo_count - 1
  end

  it "should only delete the profile-to-photo association, not destroy the asset" do
    user = users(:valid_bob)
    log_in(user)
    photo = assets(:basic_1)
    photo_count = user.profile.photos.size
    delete :destroy, :user_id => user.to_param, :id => photo.id
    user.reload
    Photo.find_by_id(photo.id).should_not be_nil
  end

end
