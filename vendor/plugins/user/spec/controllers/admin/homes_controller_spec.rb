require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HomesController, "in general" do
  it "should be an admin controller" do
    controller.is_a?(Admin::AdminController).should be_true
  end
end

describe Admin::HomesController, "#show" do
  it "GET 'show' should be successful" do
    log_in_as_admin
    get 'show'
    response.should be_success
  end
end
