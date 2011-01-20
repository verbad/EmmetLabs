dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe PrimaryProfilePhotoController, "#update" do
  it "sets the primary photo for this user" do
    user = users(:valid_bob)
    log_in(user)
    user.profile.primary_photo.should == assets(:basic_1)
    put :update, :user_id => user.to_param, :id => assets(:basic_2).to_param
    user.reload.profile.primary_photo.should == assets(:basic_2)
  end

  it "should not allow a user to set another users primary profile photo" do
    user = users(:valid_huang)
    log_in(user)
    other_user = users(:valid_bob)
    
    profile_photo1 = assets(:basic_1)
    profile_photo2 = assets(:basic_2)
    other_user.profile.primary_photo.should == profile_photo1

    proc { put :update, :user_id => other_user.to_param, :id => profile_photo2.to_param }.should raise_error(SecurityTransgression)

    other_user.reload
    other_user.profile.primary_photo.should == profile_photo1
  end

end