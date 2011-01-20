require File.dirname(__FILE__) + '/../spec_helper'

describe PasswordController, "#update" do
  integrate_views
  
  before(:each) do
    @user = users(:valid_bob)
    log_in @user
  end

  it "should not update password if validations fails" do
    put :update, :user_id => @user.to_param, :user => {:current_password => 'password', :password => 'new_password', :password_confirmation => 'bad'}
    response.should be_success
    response.should render_template('edit')
    User.authenticate(:email_address => @user.email_address, :password => 'new_password').should be_nil
  end

  it "should update password if validations succeeds" do
    put :update, :user_id => @user.to_param, :user => {:current_password => 'password', :password => 'new_password', :password_confirmation => 'new_password'}
    response.should be_redirect
    User.authenticate(:email_address => @user.email_address, :password => 'new_password').should == @user     
  end
  
end
