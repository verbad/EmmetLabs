require File.dirname(__FILE__) + '/../../spec_helper'

class AdminTestingController < Admin::AdminController
  def show
    render :text => "SHOW"
  end
end

describe AdminTestingController, "authorization" do

  it "must be logged in" do
    get 'show'
    response.should redirect_to(login_path)
  end

  it "must be logged in as admin" do
    log_in users(:valid_bob)
    proc { get 'show' }.should raise_error(SecurityTransgression)
  end

  it "should allow admins" do
    log_in users(:admin)
    get 'show'
    response.should be_success
    response.body.should == "SHOW"
  end
end
