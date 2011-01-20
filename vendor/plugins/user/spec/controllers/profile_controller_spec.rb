dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe ProfileController, "#route_for" do
  include ActionController::UrlWriter

  it "should map for #show" do
    route_for(:controller => "profile", :action => "show", :user_id => "42").should == "/users/42/profile"
  end

  it "should support helper method for #show" do
    user_profile_path(users(:valid_bob)).should == "/users/#{users(:valid_bob).to_param}/profile"
  end
end

describe ProfileController, "#show" do
  it "should raise an exception if a nonexistent user param is passed for user_id param" do
    nonexistent_user_param = "bogus_id"
    lambda { get :show, :user_id => nonexistent_user_param}.should raise_error(ActiveRecord::RecordNotFound)
  end
end
