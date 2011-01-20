require File.dirname(__FILE__) + '/../spec_helper'

describe PasswordResetToken, 'validations' do
  before(:each) do
    @token = tokens(:password_reset_token)
    @user = @token.user
  end
  
  it "should be valid if user is valid" do
    @token.attributes = { :password => "new_password", :password_confirmation => "new_password" }
    @token.should be_valid
    @token.attributes = { :password => "new_password", :password_confirmation => "different_password" }
    @token.should_not be_valid
    @token.errors[:user].should_not be_nil
  end

  it "is not valid if expired" do
    @token.expires_at = Time.now - 1.hour
    @token.should_not be_valid
    @token.errors[:expired].should_not be_nil
  end

  it "is not valid if used" do
    @token.used = true
    @token.should_not be_valid
    @token.errors[:used].should_not be_nil
  end

  it "is not valid if the user's account is not validated" do
    token = PasswordResetToken.new(:user => users(:unverified_user))
    token.should_not be_valid
    token.errors[:account_verified].should_not be_nil
  end
end

describe PasswordResetToken, 'callbacks' do
  before(:each) do
    @token = tokens(:password_reset_token)
    @user = @token.user
  end
    
  it "should be used after save and the user's password should be changed" do
    @token.should_not be_used
    @token.update_attributes(:password => "new_password", :password_confirmation => "new_password")
    @token.should be_used
    User.authenticate(:email_address => @user.email_address, :password => "new_password").should == @user
  end

  it "should be used after save and the user's password should be changed" do
    PasswordResetToken.create(:user => users(:valid_bob)).should_not be_used
  end

  it "should send a password reset email after create" do
    ActionMailer::Base.deliveries.first.should be_nil
    PasswordResetToken.create(:user => users(:valid_bob))
    ActionMailer::Base.deliveries.first.should_not be_nil
  end

end
