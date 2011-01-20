require File.dirname(__FILE__) + '/../spec_helper'

describe EmailAddress, "helper methods" do
  before :each do
    @email_address = email_addresses(:valid_bob_primary)
  end

  it "should return address for to_s" do
    @email_address.to_s.should == @email_address.address    
  end

end

describe EmailAddress, "validations" do
  before :each do
    @email_address = email_addresses(:valid_bob_primary)
  end

  it "should validate format of email_address" do
    @email_address.address = "ba@demailaddress"
    @email_address.should_not be_valid
    @email_address.errors.full_messages.should == ["The email address you provided is not valid"]
  end

  it "should validate that non-validated emails cannot be made primary if there are already validated emails" do
    email_addresses(:valid_bob_unverified).should_not be_primary
    email_addresses(:valid_bob_unverified).primary = true
    email_addresses(:valid_bob_unverified).save
    email_addresses(:valid_bob_unverified).should_not be_valid
    email_addresses(:valid_bob_unverified).errors.full_messages.should include("An unvalidated email address cannot be made primary".customize)
  end

  it "should allow a non-validated primary email address if no other validated email exists" do
    email_addresses(:unverified_user).should be_valid
  end

  it "should not allow an address to be a duplicate of another validated email address" do
    email_address = EmailAddress.new(:user => users(:valid_bob), :address => email_addresses(:huang).address)
    email_address.should_not be_valid
    email_address.errors.full_messages.should include("The email address you provided is already taken")
  end

  it "should allow a address if it is not a duplicate of another validated email address" do
    email_address = EmailAddress.new(:user => users(:valid_bob), :address => "some_unique_address@here.com")
    email_address.should be_valid
  end

  it "should allow a address to be a duplicate of another UNVALIDATED email address" do
    email_address = EmailAddress.new(:user => users(:valid_bob), :address => email_addresses(:unverified_user).address)
    email_address.should be_valid
  end

  it "should cascade deletes to email_verification_tokens" do
    token = tokens(:email_verification_token)
    email = email_addresses(:unverified_user)
    token.tokenable.should == email
    email.destroy
    Token.find_by_id(token.id).should be_nil
  end
end

describe EmailAddress, "validating all" do
  before do
    EmailAddress.requires_verification_for :all
  end

  it "should create all new email addresses in an unvalidated state" do
    email_address = EmailAddress.create(:user => new_user, :address => 'foo@bar.com')
    email_address.should_not be_verified
  end

  it "should create all subsequent email addresses in an unvalidated state" do
    email_address = EmailAddress.new(:user => users(:valid_bob))
    email_address.should_not be_verified
  end

  it 'should create an email validation token on create of first email address' do
    email_address = EmailAddress.create(:user => new_user, :address => 'foo@bar.com')
    email_address.verification_tokens.size.should == 1
  end

  it 'should create an email validation token on create for subsequent email address' do
    email_address = EmailAddress.create(:user => users(:valid_bob), :address => 'foo@bar.com')
    email_address.verification_tokens.size.should == 1
  end
end

describe EmailAddress, "validating first" do
  before do
    EmailAddress.requires_verification_for :first
  end

  it "should create first email address for user in an unvalidated state" do
    email_address = EmailAddress.create(:user => new_user, :address => 'foo@bar.com')
    email_address.should_not be_verified
  end

  it "should create all subsequent email addresses for user in a validated state" do
    email_address = EmailAddress.create(:user => users(:valid_bob), :address => "new_address2@here.com")
    email_address.should be_verified
  end

  it 'should create an email validation token on create of first email address' do
    email_address = EmailAddress.create!(:user => new_user, :address => 'foo@bar.com')
    email_address.verification_tokens.size.should == 1
  end

  it 'should not create an email validation token on create for subsequent email addresses' do
    email_address = EmailAddress.create!(:user => users(:valid_bob), :address => "new_address2@here.com")
    email_address.verification_tokens.should be_empty
  end

end

describe EmailAddress, "associations" do
  it "should belong to a user" do
    email_addresses(:valid_bob_primary).user.should == users(:valid_bob)
  end
end

describe EmailAddress, "finders" do
  it "should have_finder validated" do
    users(:valid_bob).email_addresses.verified.should == [email_addresses(:valid_bob_primary), email_addresses(:valid_bob_verified)]
  end
end

describe EmailAddress, 'security' do
  it "should prevent mass-assignment of validated" do
    email_addresses(:valid_bob_unverified).should_not be_verified

    begin
      email_addresses(:valid_bob_unverified).attributes = {:verified => true}
    rescue Exception => e
      e.class.should == ActiveRecord::ProtectedAttributeAssignmentError # Rails 2.0
    end
    email_addresses(:valid_bob_unverified).should_not be_verified # rails 1.2
  end
end

describe EmailAddress, 'callbacks' do
  it 'should set all other emails as not-primary when set as primary' do
    email_addresses(:valid_bob_primary).should be_primary
    email_addresses(:valid_bob_verified).should_not be_primary
    email_addresses(:valid_bob_verified).primary = true
    email_addresses(:valid_bob_verified).save!
    email_addresses(:valid_bob_primary).reload.should_not be_primary
    email_addresses(:valid_bob_verified).reload.should be_primary
  end
end

describe EmailAddress, 'class methods' do
  it "should allow setting of validation requirements" do
    EmailAddress.requires_verification_for :all
    EmailAddress.should be_verifies_all
    EmailAddress.requires_verification_for :first
    EmailAddress.should be_verifies_first
  end
end

describe EmailAddress, 'permissions' do
  it "is destroyable only by the user and if it is not primary" do
    email_addresses(:valid_bob_primary).should_not be_destroyable_by(users(:valid_bob))
    email_addresses(:valid_bob_verified).should be_destroyable_by(users(:valid_bob))
    email_addresses(:valid_bob_verified).should_not be_destroyable_by(users(:valid_huang))
  end

  it "is updatable only by the user" do
    email_addresses(:valid_bob_verified).should be_updatable_by(users(:valid_bob))
    email_addresses(:valid_bob_verified).should_not be_updatable_by(users(:valid_huang))
  end
end