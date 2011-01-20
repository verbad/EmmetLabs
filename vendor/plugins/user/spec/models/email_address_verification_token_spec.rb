require File.dirname(__FILE__) + '/../spec_helper'

describe EmailAddressVerificationToken, 'validations' do
  it "should validate the token is not expired on update" do
    token = tokens(:email_verification_token)
    token.should be_valid
    token.expires_at = (Time.now - 1.hour).to_s(:db)
    token.should_not be_valid
    token.errors[:expired].should_not be_nil
  end

  it "should validate the token is not used on update" do
    token = tokens(:email_verification_token)
    token.should be_valid
    token.used = true
    token.should_not be_valid
    token.errors[:used].should_not be_nil
  end

  it "should not be able to create a token if email address is already validated" do
    token = EmailAddressVerificationToken.new(:email_address => email_addresses(:valid_bob_primary))
    token.should_not be_valid
    token.errors.full_messages.should == ["This email address has already been validated"]
  end

  it "should be able to create a token if email address is not already validated" do
    token = EmailAddressVerificationToken.new(:email_address => email_addresses(:unverified_user))
    token.should be_valid
  end
end

describe EmailAddressVerificationToken, 'callbacks' do
  it "should send out validation email when created" do
    ActionMailer::Base.deliveries.first.should be_nil
    EmailAddressVerificationToken.create(:email_address => email_addresses(:unverified_user))
    ActionMailer::Base.deliveries.first.should_not be_nil
  end

  it "should mark as used on update" do
    token = tokens(:email_verification_token)
    token.should_not be_used
    token.save!
    token.should be_used
  end

  it "should verify the account on update" do
    token = tokens(:email_verification_token)
    user = token.user
    user.should_not be_account_verified
    token.save!
    user.reload.should be_account_verified
  end
end