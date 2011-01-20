dir = File.dirname(__FILE__)
require "#{dir}/../../spec_helper"

describe Admin::UsersController, "in general" do
  it "should be an admin controller" do
    controller.is_a?(Admin::AdminController).should be_true
  end
end

describe Admin::UsersController, "#index, when not logged in" do
  integrate_views
  
  it "should redirect to the login page" do
    assert_not_logged_in
    get :index
    response.should redirect_to(login_path)
    assert_not_logged_in
  end

  it "should not allow non-admin" do
    non_admin = users(:valid_bob)
    non_admin.should_not be_super_admin
    log_in(non_admin)

    proc{get :index}.should raise_error(SecurityTransgression)
  end

  it "should list users for admin" do
    log_in_as_admin
    count = User.count

    get :index
    assigns(:users).size.should == count

    User.create!(:email_address => 'newguy@example.com',
      :password => 'password',
      :password_confirmation => 'password',
      :unique_name => 'Newey',
      :accept_terms_of_service => '1')

    get :index
    assigns(:users).size.should == count + 1
  end
end

describe Admin::UsersController, "#create" do
  integrate_views

  before(:each) do
    @admin = log_in_as_admin
    @newguy_attributes = new_user_attributes(:accept_terms_of_service => '1')
    @newguy_email =  "newguy@example.com"
    @newguy_attributes[:email_address].should == @newguy_email
    User.find_by_email_address(@newguy_email).should be_nil
  end

  it "should automatically accept terms of service" do
    @newguy_attributes[:accept_terms_of_service] = '0'
    post :create, :user => @newguy_attributes
    new_user = User.find_by_email_address(@newguy_email)
    new_user.should_not be_needs_to_accept_tos 
  end
  
  it "should automatically verify primary email address and NOT send validation email" do
    post :create, :user => @newguy_attributes
    new_user = User.find_by_email_address(@newguy_email)
    new_user.primary_email_address.verified.should be_true
    ActionMailer::Base.deliveries.first.should be_nil    
  end
  
  it "should redirect to admin users and remain logged in as super admin when successful" do
    post :create, :user => @newguy_attributes
    User.find_by_email_address(@newguy_email).should_not be_nil

    response.should redirect_to(admin_users_path)
    assert_logged_in_as(@admin)
  end
end

describe Admin::UsersController, "#update" do
  integrate_views

  it "should not allow non-admin" do
    non_admin = users(:valid_bob)
    non_admin.should_not be_super_admin
    log_in(non_admin)

    proc{post :update}.should raise_error(SecurityTransgression)
  end

  it "should allow admin to change a user to be an admin" do
    log_in_as_admin
    non_admin = users(:valid_bob)
    non_admin.should_not be_super_admin

    post :update, :id => non_admin.to_param, :user => {:super_admin => 'true'}
    non_admin.reload
    non_admin.should be_super_admin
  end

  it "should allow admin to change a user to not be an admin anymore" do
    log_in_as_admin
    non_admin = users(:valid_bob)
    non_admin.super_admin = true
    non_admin.save!
    non_admin.should be_super_admin

    post :update, :id => non_admin.to_param, :user => { :super_admin => 'false'}
    non_admin.reload
    non_admin.should_not be_super_admin
  end
end

describe Admin::UsersController, "#delete" do
  it "should be logged in" do
    post :destroy
    response.should redirect_to(login_path)
  end

  it "should not allow non-admin" do
    non_admin = users(:valid_huang)
    non_admin.should_not be_super_admin
    log_in(non_admin)

    proc{post :destroy}.should raise_error(SecurityTransgression)
  end

  it "should allow admin to delete a user" do
    log_in_as_admin
    user_to_be_deleted = users(:valid_huang)
    controller.should_receive(:on_successful_destroy)

    post :destroy, {:id => user_to_be_deleted.to_param}
    User.find_by_id(user_to_be_deleted.id).should be_nil
  end

  it "should invoke on_failed_destroy when destroy fails" do
    log_in_as_admin
    original_user_count = User.count
    @user = mock_model(User, :account_verified? => true, :super_admin? => true)
    User.stub!(:find_by_param).and_return(@user)
    @user.should_receive(:destroy).and_return(false)
    controller.should_receive(:on_failed_destroy)
    
    post :destroy, {:id => users(:valid_huang).to_param}
    User.count.should == original_user_count
  end

  it "should blow up when invalid id was passed" do
    log_in_as_admin
    original_user_count = User.count

    proc {post :destroy, {:id => '-9999'}}.should raise_error(Exception)
    User.count.should == original_user_count
  end
end

