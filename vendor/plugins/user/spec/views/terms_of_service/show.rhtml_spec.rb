require File.dirname(__FILE__) + '/../../spec_helper'

describe "/terms_of_service/show.html.erb" do
  it_should_behave_like "TOS exists"

  before do
    assigns[:terms_of_service] = @tos
  end

  it "should render title with revision" do
    render "/terms_of_service/show.html.erb"
    response.should have_text(/Terms of Service.*#{@tos.revision}/i)
  end

  it "should render text" do
    render "/terms_of_service/show.html.erb"
    response.should have_text(/#{@tos.text}/i)
  end

end

