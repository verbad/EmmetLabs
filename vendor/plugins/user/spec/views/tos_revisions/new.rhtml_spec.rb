require File.dirname(__FILE__) + '/../../spec_helper'

describe "/tos_revisions/new.html.erb with an invalid tos" do
  before do
    assigns[:tos_revision] = TermsOfService.create
  end

  it "should display error message" do
    render "/tos_revisions/new.html.erb"
    response.should have_text(/Text cannot be blank/i)
  end

end