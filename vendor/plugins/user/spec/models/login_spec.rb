require File.dirname(__FILE__) + '/../spec_helper'

describe Login, 'validations' do
  it "is valid with a correct email_address and password" do
    login = Login.new(:email_address => users(:valid_bob).email_address, :password => 'password')
    login.should be_valid

    login = Login.new(:email_address => 'valid_bob', :password => 'password')
  end

  it "is invalid with a correct email_address and incorrect password" do
    login = Login.new(:email_address => users(:valid_bob).email_address, :password => 'bad_password')
    login.should_not be_valid
    login.errors[:password].should_not be_nil
  end

  it "is invalid if user is disabled" do
    disabled_user = users(:valid_bob)
    disabled_user.disabled = true
    disabled_user.save!
    login = Login.new(:email_address => disabled_user.email_address, :password => 'password')
    login.should_not be_valid
    login.errors[:base].should match(/disabled/)
  end

  it "is invalid with an incorrect email_address and correct password" do
    login = Login.new(:email_address => 'bad_email', :password => 'password')
    login.should_not be_valid
    login.errors[:password].should_not be_nil
  end

  it "should allow the user to log out after creating the first new TOS" do
    admin = users(:admin)
    login = Login.create(:email_address => admin.email_address, :password => 'password')
    TermsOfService.create!(:text => 'My TOS')

    login.destroy.should_not be_false
    login.should be_valid
  end
end

describe Login, 'validations with existing tos' do
  it_should_behave_like "TOS exists"

  it "is invalid if tos exists and the user needs to accept terms of service" do
    login = Login.new(:email_address => users(:user_with_old_tos).email_address, :password => 'password')
    login.should_not be_valid
    login.errors[:accept_terms_of_service].should_not be_nil
  end
end

describe Login, 'callbacks' do
  it_should_behave_like "TOS exists"
  it "should increment TOS" do
    users(:user_with_old_tos).needs_to_accept_tos?.should be_true
    login = Login.new(:email_address => users(:user_with_old_tos).email_address, :password => 'password', :accept_terms_of_service => '1')
    login.save
    users(:user_with_old_tos).reload.needs_to_accept_tos?.should be_false
  end
end