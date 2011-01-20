require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe SearchResultsController do
  it_should_behave_like 'login'
  it "should find people by name" do
    get :show, :search_query => 'joseph'
    response.should be_success
    assigns[:people].should_not be_empty
    assigns[:search_query].should == 'joseph'
  end
end

describe SearchResultsController do
  it "should require login" do
    get :show
    response.response_code.should == 302
  end
end
