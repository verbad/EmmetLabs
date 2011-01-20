dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe TosRevisionsController, "#route_for" do
  include ActionController::UrlWriter

  it "should map for #index" do
    route_for(:controller => "tos_revisions", :action => "index").should == "/tos_revisions"
  end

  it "should support helper method for #index" do
    tos_revisions_path.should == "/tos_revisions"
  end
end

describe TosRevisionsController, "#index" do
  it_should_behave_like "TOS exists"

  it "should redirects to log in page when not logged in" do
    get :index
    response.response_code.should == 302
  end

  it "should return a collection of ordered TOS revisions by admin" do
    log_in(users(:admin))
    get :index
    response.should be_success
    assigns(:tos_revisions).should == TermsOfService.find(:all, :order => 'revision DESC')
  end

end

describe TosRevisionsController, "#show" do
  it_should_behave_like "TOS exists"

  it "should return a TOS revisions by admin" do
    user = users(:admin)
    log_in(user)
    get :show, :id => @tos
    assigns[:tos_revision].should == @tos
  end

  it "should not render a page by non admin" do
    user = users(:valid_bob)
    log_in(user)
    proc do
      get :show, :id => @tos.id
    end.should raise_error(SecurityTransgression)
  end
end

describe TosRevisionsController, "#new" do
  include ActionController::UrlWriter

  it "should render a page with new terms of service object by admin" do
    user = users(:admin)
    log_in(user)
    get :new
    assigns[:tos_revision].should_not be_nil
  end
  
end

describe TosRevisionsController, "#create" do
  it_should_behave_like "TOS exists"

  it "should create new terms of service object by admin" do
    user = users(:admin)
    log_in(user)
    text = 'blar blar'
    revision = TermsOfService.latest.revision
    post :create, :tos_revision => {:text => text }
    response.should be_redirect
    new_revision = TermsOfService.latest
    new_revision.text.should == text
    new_revision.revision.should == (revision + 1)    
  end

  it "should render new page with error by admin" do
    user = users(:admin)
    log_in(user)
    post :create
    response.should render_template('new')
  end

  it "should not create new terms of service object by non admin" do
    user = users(:valid_bob)
    log_in(user)
    proc do
      post :create, :tos_revision => {:text => 'foo' }
    end.should raise_error(SecurityTransgression)
  end
end
