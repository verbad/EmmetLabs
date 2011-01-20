require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController, "#create" do
  integrate_views

  before(:each) do
    @newguy_attributes = new_user_attributes
    @newguy_email =  "newguy@example.com"
    @newguy_attributes[:email_address].should == @newguy_email
    User.find_by_email_address(@newguy_email).should be_nil
  end

  it "should create a new user when valid" do
    post :create, :user => @newguy_attributes
    User.find_by_email_address(@newguy_email).should_not be_nil
    response.should redirect_to(new_email_address_verification_request_path(assigns(:user), assigns(:user).primary_email_address))
    assert_logged_in_as(assigns(:user))
  end

  it "should fail if user didn't validate match" do
    post :create, :user => new_user_attributes(:password_confirmation => "different")
    response.should render_template("new")
    assigns(:user).should_not be_nil
    User.find_by_email_address(@newguy_email).should be_nil
  end

  it "should redirect back if create succeeds and there's a redirect location in session" do
    request.session[:location] = "/"
    post :create, :user => @newguy_attributes
    User.find_by_email_address(@newguy_email).should_not be_nil
    response.should redirect_to("/")
  end
end

describe UsersController, "#update" do
  integrate_views

  before(:each) do
    @user = users(:valid_bob)
    @user.authenticate?("password").should == @user
    log_in(@user)
  end

  it "should re-render edit page if there's an error" do
    faulty_attributes = {:email_address => "bad-addr"}
    put :update, :id => @user.to_param, :user => faulty_attributes
    response.should render_template("edit")
    assigns(:user).should_not be_nil
    assigns(:user).should_not be_valid
  end

  it "should update user, if successful" do
    put :update, :id => @user.to_param,
        :user => {:email_address => 'bob@example.com'}
    response.should redirect_to(@controller.send(:user_url, @user))
    flash[:notice].should == "User was successfully updated."
    assigns(:user).should be_valid
    @user.reload
  end
end

describe UsersController, "#list" do
  integrate_views

  before(:each) do
    @user1 = users(:valid_bob)
    @user2 = users(:valid_huang)
    get :index
  end

  it "should assign user list to all users" do
    response.should be_success
    response.should render_template("index")
    assigns(:users).should_not be_nil
    assigns(:users).all? {|user| user.should be_instance_of(User)}
    assigns(:users).length.should == User.count
  end
end

describe UsersController, "#edit" do
  integrate_views

  it "should render edit page if logged in" do
    user = users(:valid_bob)
    log_in(user)
    get :edit, :id => user.to_param
    response.should render_template("edit")
  end

  it "should redirect to login if not logged in" do
    user = users(:valid_bob)
    get :edit, :id => user.to_param
    response.should redirect_to(@controller.send(:login_url))
  end

  it "should return forbidden response if a logged-in user attempts to edit another user" do
    user = users(:valid_bob)
    log_in(user)
    other_user = users(:valid_huang)
    proc { get :edit, :id => other_user.to_param }.should raise_error(SecurityTransgression)
  end
end

describe UsersController, "#show" do
  integrate_views

  it "should show a user" do
    get :show, :id => users(:valid_bob).to_s
    response.should render_template("show")
    assigns(:user).should == users(:valid_bob)
  end
end

describe "SSL redirects" do
  integrate_views
  controller_name :users

  it "works when use_ssl is on" do
    # SecureActions.redefine_const(:USE_SSL, true)
    get :new
    response.should redirect_to("https://test.host/users/new")
    post :create
    response.should redirect_to("https://test.host/users")
  end

  after(:each) do
    # SecureActions.redefine_const(:USE_SSL, false)
  end
end
