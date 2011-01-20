require File.dirname(__FILE__) + '/../spec_helper'

describe ContentPagesController do
  it_should_behave_like 'login'

  describe "handling GET /content_pages/1" do

    before(:each) do
      @content_page = content_pages(:guidelines)
      ContentPage.stub!(:find).and_return(@content_page)
    end

    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render show template" do
      do_get
      response.should render_template('show')
    end

    it "should find the content_page requested" do
      ContentPage.should_receive(:find).with("1").and_return(@content_page)
      do_get
    end

    it "should assign the found content_page for the view" do
      do_get
      assigns[:content_page].should equal(@content_page)
    end
  end

end

describe ContentPagesController do
  it "should require login" do
    get :show, :id => "1"
    response.response_code.should == 302
  end
end

describe ContentPagesController do
  describe "route recognition" do
    it "should generate params { :controller => 'content_pages', action => 'show', name => 'foo_bar' } from GET /pages/foo_bar" do
      params_from(:get, "/pages/foo_bar").should == {:controller => "content_pages", :action => "show", :name => "foo_bar"}
    end
  end
end
