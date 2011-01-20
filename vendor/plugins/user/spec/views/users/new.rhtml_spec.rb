require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/new.html.erb" do
  it_should_behave_like "TOS exists"

  before do
    assigns[:user] = User.new
  end

  it "should render a checkbox to accept terms of service" do
    render "/users/new.html.erb"
    response.should have_text(/id=\"accept_terms_of_service\"/)
  end

end