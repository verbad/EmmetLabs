require File.dirname(__FILE__) + '/../../spec_helper'

describe "/network/show" do
  it "should work" do
    assigns[:directed_relationship_history] = []
    assigns[:target_person] = people(:jim)
    assigns[:people] = people(:jim).relatives
    render "/network/show.rxml"
    response.should be_success
  end
end