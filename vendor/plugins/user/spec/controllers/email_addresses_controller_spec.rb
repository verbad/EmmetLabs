require File.dirname(__FILE__) + '/../spec_helper'

describe EmailAddressesController, "#routes" do
  include ActionController::UrlWriter

  it "should map for #index" do
    route_for(:controller => "email_addresses", :action => "index", :user_id => "bob").should == "/users/bob/email_addresses"
  end

  it "should support helper method for #index" do
    user_email_addresses_path(users(:valid_bob)).should == "/users/#{users(:valid_bob).to_param}/email_addresses"
  end

  it "should support helper method for #new" do
    new_user_email_address_path(users(:valid_bob)).should == "/users/#{users(:valid_bob).to_param}/email_addresses/new"
  end
end

describe EmailAddressesController, "#new" do
  integrate_views

  it "should assign the user to the new email address" do
    log_in(users(:valid_bob))
    get :new, :user_id => users(:valid_bob).to_param
    response.should be_success
    assigns(:email_address).user.should == users(:valid_bob)
  end

end

describe EmailAddressesController, "#create" do
  integrate_views

  before do
    log_in(users(:valid_bob))
  end

  it "should redirect to such and such on successful create" do
    original_email_count = users(:valid_bob).email_addresses.count
    post :create, :user_id => users(:valid_bob).to_param, :email_address => {:address => 'foo@bar.com'}
    users(:valid_bob).email_addresses.count.should == original_email_count + 1
    response.should be_redirect
  end

  it "should render the form on failed create" do
    log_in(users(:valid_bob))
    post :create, :user_id => users(:valid_bob).to_param, :email_address => {:address => 'foo@@@'}
    response.should render_template(:new)
  end

end

describe EmailAddressesController, "#show" do
  integrate_views

  before do
    log_in(users(:valid_bob))
  end

  it "should work" do
    get :show, :user_id => users(:valid_bob).to_param, :id => email_addresses(:valid_bob_primary)
    assigns(:email_address).should == email_addresses(:valid_bob_primary)
    response.should be_success
  end

end

describe EmailAddressesController, "#index" do
  integrate_views

  before do
    log_in(users(:valid_bob))
  end

  it "should work" do
    get :index, :user_id => users(:valid_bob).to_param
    assigns(:email_addresses).should == users(:valid_bob).email_addresses
    response.should be_success
    response.should render_template(:index)
  end

end

describe EmailAddressesController, "#destroy" do
  integrate_views

  before do
    log_in(users(:valid_bob))
  end

  it "should redirect to #index on successful destroy" do
    delete :destroy, :user_id => users(:valid_bob).to_param, :id => email_addresses(:valid_bob_unverified).to_param
    proc { email_addresses(:valid_bob_unverified).reload }.should raise_error(ActiveRecord::RecordNotFound)
    response.should redirect_to(user_email_addresses_path(users(:valid_bob)))
  end
end


describe EmailAddressesController, "#update" do
  integrate_views

  before do
    log_in(users(:valid_bob))
  end

  it "should redirect to #index on successful update" do
    email_addresses(:valid_bob_verified).reload.should_not be_primary
    put :update, :user_id => users(:valid_bob).to_param, :id => email_addresses(:valid_bob_verified).to_param, :email_address => {:primary => '1'}
    email_addresses(:valid_bob_verified).reload.should be_primary
    response.should redirect_to(user_email_addresses_path(users(:valid_bob)))
  end
end

