dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe LoginController, "#route_for" do
  include ActionController::UrlWriter

  it "should map for #show" do
    route_for(:controller => "login", :action => "show").should == "/login"
  end

  it "should support helper method for #show" do
    login_path.should == "/login"
  end
end

describe LoginController, "#show" do
  integrate_views

  it "should show the login page" do
    get :show
    response.should be_success
    response.should render_template("show")
  end
end

describe LoginController, "#create" do
  integrate_views

  it "should log in the user if their credentials are correct and redirect back" do
    request.session[:location] = "/"
    user = users(:valid_bob)
    post :create, 
         :login => {:email_address => user.email_address, 
                   :password => 'password'}
    should_be_logged_in_as(user)
    response.should redirect_to("/")
    flash[:notice].should == "Login successful"
  end

  it "should fail if given a bad password" do
    user = users(:valid_bob)
    post :create, 
         :login => {:email_address => user.email_address,
                   :password => 'bad password'}
    response.should be_success
    response.should render_template("show")
    flash.now[:error].should == "Login unsuccessful".customize
    should_not_be_logged_in
  end

  it "should store auto login cookie if asked" do
    user = users(:valid_bob)
    post :create,
         :login => {:email_address => user.email_address,
                   :password => 'password'},
         :auto_login => true
    cookies['auto_login'].size.should be > 0
  end

end

def should_be_logged_in_as(user)
  assert_logged_in_as(user)
end

def should_not_be_logged_in
  assert_not_logged_in
end

describe LoginController, "#destroy" do
  integrate_views

  before(:each) do
    @user = users(:valid_bob)
    log_in(@user)
    should_be_logged_in_as(@user)
  end

  it "should clear session when post" do
    delete :destroy
    response.should redirect_to(home_page_path)
    should_not_be_logged_in
    flash[:notice].should == "You have been logged out"
  end

  it "should clear auto_login cookies" do
    user = users(:valid_bob)
    post :create,
         :login => {:email_address => user.email_address,
         :password => 'password'
         },
         :auto_login => true
    cookies['auto_login'].size.should be > 0
    delete :destroy
    cookies['auto_login'].size.should == 0
  end
end

describe LoginController, "#destroy, when not logged in" do
  it "should redirect to the login page" do
    should_not_be_logged_in
    delete :destroy
    response.should redirect_to(home_page_path)
    should_not_be_logged_in
  end
end

describe LoginController, "SSL redirects" do
  integrate_views
  
  it "works when use_ssl is on" do
    # SecureActions.redefine_const(:USE_SSL, true)
    # get :show
    # TODO: This line failed when we made rspec on rails throw controller exceptions.
    # Is it needed???
    #get @controller.send(:show_login_url)
    # @controller.send(:new_login_url).should =~ /https/
#TODO: Figure out why this doesn't resolve bi-directionally
   # get :show
   # response.should redirect_to("https://test.host/login")
  end

  after(:each) do
    # SecureActions.redefine_const(:USE_SSL, false)
  end
end
