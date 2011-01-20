require File.dirname(__FILE__) + '/../spec_helper'

class StubController < ApplicationController
  def show
    render :text => "SHOW"
  end
end

describe "ApplicationControllerSpec fixture", :shared => true do
  before do
    user = users(:valid_bob)
    log_in user
    user.disabled = true
    user.save!
    get 'show'
    user.reload
    should_not be_logged_in
  end
end

describe StubController, "before filter" do
  it_should_behave_like "ApplicationControllerSpec fixture"

  it "prevents all access for disabled users" do
    response.should redirect_to(login_path)
  end
end

describe LoginController, "before filter" do
  it_should_behave_like "ApplicationControllerSpec fixture"

  it "prevents all access for disabled users but does not to an infinite redirect" do
    response.should_not redirect_to(login_path)
  end
end
