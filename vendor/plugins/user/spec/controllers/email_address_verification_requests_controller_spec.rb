dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe EmailAddressVerificationRequestsController, "#routes" do
  include ActionController::UrlWriter

  it "should map for #index" do
    route_for(:controller => "email_address_verification_requests", :action => "index", :user_id => users(:valid_bob).to_param, :email_address_id => 1).should == "/users/#{users(:valid_bob).to_param}/email_addresses/1/verification_requests"
  end

  it "should support helper method for #index" do
    email_address_verification_requests_path(users(:valid_bob), email_addresses(:valid_bob_primary)).should == "/users/#{users(:valid_bob).to_param}/email_addresses/#{email_addresses(:valid_bob_primary).to_param}/verification_requests"
  end

  it "should support helper method for #new" do
    new_email_address_verification_request_path(users(:valid_bob), email_addresses(:valid_bob_primary)).should == "/users/#{users(:valid_bob).to_param}/email_addresses/#{email_addresses(:valid_bob_primary).to_param}/verification_requests/new"
  end
end

describe EmailAddressVerificationRequestsController, "#show" do
  integrate_views

  it "should assign token" do
    get :show, :user_id => users(:unverified_user).to_param, :email_address_id => users(:unverified_user).primary_email_address.to_param, :id => tokens(:email_verification_token).to_param
    response.should be_success
    assigns(:token).should == tokens(:email_verification_token)
  end
end

describe EmailAddressVerificationRequestsController, "#new" do
  integrate_views

  it "should assign user" do
    log_in(users(:unverified_user))
    get :new, :user_id => users(:unverified_user).to_param, :email_address_id => users(:unverified_user).primary_email_address.to_param
    response.should be_success
  end
end

def should_be_logged_in_as(user)
  assert_logged_in_as(user)
end

def should_not_be_logged_in
  assert_not_logged_in
end

describe EmailAddressVerificationRequestsController, "#create" do
  integrate_views

  before(:each) do
    @user = users(:unverified_user)
    @user.should_not be_account_verified
    @token = tokens(:email_verification_token)
    @token.should_not be_used
    log_in @user
  end

  it "should resend the validation email if the user exists" do
    post :create, :user_id => users(:unverified_user).to_param, :email_address_id => users(:unverified_user).primary_email_address.to_param
    @user.reload
    assigns(:token).should_not be_used
    flash[:notice].should =~ /A new validation email has been sent to unverified_user@example.com/
    response.should redirect_to(home_page_path)
  end
end

describe EmailAddressVerificationRequestsController, "#update" do
  integrate_views

  before(:each) do
    @user = users(:unverified_user)
    @user.should_not be_account_verified
    @token = tokens(:email_verification_token)
    @token.should_not be_used
  end

  it "should login and verify the user if the token is valid" do
    put :update, :user_id => users(:unverified_user).to_param, :email_address_id => users(:unverified_user).primary_email_address.to_param, :id => @token.to_param
    @user.reload.should be_account_verified
    @token.reload.should be_used
    flash[:notice].should == "Your address has been verified. Welcome!"
    response.should redirect_to("/")
  end

  it "should redirect to correct path on failure" do
    @token.save!

    user = users(:unverified_user)
    address = user.primary_email_address

    put :update, :user_id => user.to_param, :email_address_id => address.to_param, :id => @token.to_param
    response.should redirect_to(new_email_address_verification_request_path(user, address))
  end
end
