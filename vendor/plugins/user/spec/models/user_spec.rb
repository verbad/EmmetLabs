require File.dirname(__FILE__) + '/../spec_helper'

describe "All fixtures" do
  it "should be valid" do
    User.find(:all).each do |user|
      next if user.needs_to_accept_tos?
      user.should be_valid
    end
  end
end

describe User, "with TOS required" do
  it_should_behave_like "TOS exists"

  it ", and a nil tos id, should be required to accept terms of service." do
    TermsOfService.latest.should == @tos
    user = new_user
    user.terms_of_service_id.should == nil

    user.should be_needs_to_accept_tos
    user.should_not be_valid
    user.errors.full_messages.should == ["Terms of service must be accepted."]
  end

  it ", and an outdated tos id, should be required to accept terms of service" do
    TermsOfService.latest.should_not == @old_tos
    user = new_user(:terms_of_service => @old_tos)
    user.should be_needs_to_accept_tos
  end

  it ", and a current tos id, should NOT be required to accept terms of service" do
    user = new_user
    user.terms_of_service = TermsOfService.latest
    user.should_not be_needs_to_accept_tos
  end

  it ", and an outdated tos id, should be valid if 'accept_terms_of_service' flag is set" do
    TermsOfService.latest.should == @tos
    user = new_user(:accept_terms_of_service => '1')
    user.should be_valid
  end

  it "should not be valid if user has old tos but does not set 'accept_terms_of_service' flag" do
    user = new_user(:accept_terms_of_service => '0')
    user.terms_of_service = @old_tos
    user.should_not be_valid
    user.errors[:accept_terms_of_service].should_not be_nil
  end

end

describe "A new user" do
  before(:each) do
    @user = new_user
  end

  it "should create a profile" do
    @user.save
    @user.profile.should_not be_new_record
  end

  it "should complain if password doesn't match confirmation" do
    @user.password_confirmation = "different"
    @user.should_not be_valid
    @user.errors.full_messages.should == ["Password does not match confirmation"]
  end

  it "should complain if unique name has already been taken" do
    @user.unique_name = users(:valid_bob).unique_name
    @user.should_not be_valid
    @user.errors.full_messages.should == ["Unique name has already been taken".customize]
  end

  it "should complain if unique name has invalid characters" do
    @user.unique_name = 'bob!'
    @user.should_not be_valid
    @user.errors.full_messages.should == ["Unique name must be composed of letters, digits, underscores, or hyphens".customize]
  end

  it "should not complain if unique name has only valid characters" do
    @user.unique_name = 'b_o_b-9'
    @user.should be_valid
  end

  it "should complain if either password or password confirmation is omitted" do
    @user.password = ""
    @user.password_confirmation = ""
    @user.should_not be_valid
    @user.errors.full_messages.sort.should == ["Password is too short (minimum is 3 characters)", "Please enter your password",
      "Please confirm your password"].sort
  end

  it "should allow a unique name to be set" do
    @user.unique_name ="foo1212"
    @user.should be_valid
  end

  it "should start out unverified" do
    @user.save
    @user.should_not be_account_verified
    @user.should == User.find_by_id(@user.id)
  end

  it ", created by an admin, can be created with super_admin field" do
    @user.super_admin = true
    users(:admin).should be_can_create(@user)
  end

  it ", created by a non-admin, cannot be created with super_admin field" do
    @user.super_admin = true
    @user.should_not be_can_create(@user)
  end

  it ", created by non-admin others, cannot be created with super_admin field" do
    @user.super_admin = true
    users(:valid_huang).should_not be_can_create(@user)
  end
end

describe "An existing user" do
  before(:each) do
    @user = users(:valid_bob)
  end

  it "should have a profile" do
    @user.profile.should == profiles(:for_valid_user)
  end

  it "should be able to change their unique name" do
    @user.unique_name = "foo"
    @user.should be_valid
  end

  it "should use the profile's first and last name for the full name" do
    @user.full_name.should == "Bob McValid"
  end

  it "should use the username for the full name if the profile name is blank" do
    @user.profile.first_name = ""
    @user.profile.last_name = ""
    @user.full_name.should == "valid_bob"
  end

  it "should use the first name for the full name if the last name is blank" do
    @user.profile.last_name = ""
    @user.full_name.should == "Bob"
  end

  it "should use the last name for the full name if the first name is blank" do
    @user.profile.first_name = ""
    @user.full_name.should == "McValid"
  end

  it "with a unique name set should return the unique name for to_s" do
    @user.to_s.should == users(:valid_bob).unique_name
  end
  
  it "can be disabled" do
    @user.should_not be_disabled
    @user.disabled = true
    @user.should be_disabled
  end

end

describe "An existing user with a default unique name" do
  before do
    @user = new_user(:unique_name => nil)
    @user.save
    @guid = @user[:unique_name]
  end

  it "should return a default non-guid value for to_s" do
    @user.to_s.should_not == @guid

  end

  it "should always return guid value for to_param" do
    @user.to_param.should == @guid
  end

  it "should return unique name for to_s after unique_name is updated" do
    @user.to_s.should_not == @guid
    @user.unique_name = "nowspecified"
    @user.save
    @user.to_s.should == 'nowspecified'
  end

  it "should return empty string for unique name " do
    @user.unique_name.should be_empty
  end

end

describe "Unverified users" do
  before(:each) do
    @user = users(:unverified_user)
  end

  it "should not be verified" do
    @user.should_not be_account_verified
  end

  it "should be verified once they get a verify_account! call" do
    @user.verify_account!
    @user.reload
    @user.should be_account_verified
  end
end

describe "The authenticate method" do
  it "should find valid people by their password" do
    user = users(:valid_bob)
    user.salt.should_not be_nil
    User.authenticate(:email_address => user.email_address, :password => "password").should == user
    User.authenticate(:email_address => user.email_address, :password => 'bad password').should be_nil
  end

  it "should find unverified users" do
    user = users(:unverified_user)
    User.authenticate(:email_address => user.email_address, :password => "password").should == user
  end

  it "should not erase encrypted password if in-memory user is saved" do
    user = users(:valid_bob)
    orig_encrypted_password = user.encrypted_password
    user = User.authenticate(:email_address => user.email_address, :password => "password")
    user.save!
    user.encrypted_password.should == orig_encrypted_password
  end
end

describe "The password field" do
  it "should encrypt when called through the encrypt method" do
    password = "password"
    salt = "change-me"
    encrypted = User.encrypt(password, salt)
    encrypted.should == "db9c93f05d2e41dc2256c3890d5d78ca6e48d418"
  end

  it "should encrypt when saved" do
    user = users(:valid_bob)
    user.current_password = "password"
    user.password = "new_password"
    user.password_confirmation = "new_password"
    user.save!
    user_from_db = User.find_by_email_address(user.email_address)
    User.authenticate(:email_address => user.email_address, :password => 'new_password').should == user_from_db
    user_from_db.encrypted_password.should == User.encrypt("new_password", user.salt)
  end

  it "should be blank after saved and encrypted_password generated" do
    user = users(:valid_bob)
    user.current_password = "password"
    user.password = "new_password"
    user.password_confirmation = "new_password"
    user.save!
    user.errors.should be_empty
    user.encrypted_password.should_not be_nil
    user.password.should be_nil
    user.password_confirmation.should be_nil
  end

  it 'should be valid when saved, not complain about password' do
    user = User.new(
      "password_confirmation"=>"password",
        "unique_name"=>"nathan",
        "password"=>"password",
        "email_address"=>"nathan@pivotallabs.com")
    user.should be_valid

    user.save
    user.should be_valid

    user = User.find_by_id(user.reload.id)
    user.should be_valid
  end
end

describe User, "security: update and destroy" do
  fixtures :users

  it "admin can update and destroy" do
    users(:admin).can_update?(users(:valid_bob)).should == true
    users(:admin).can_destroy?(users(:valid_bob)).should == true
  end

  it "self can update and destroy" do
    users(:valid_bob).can_update?(users(:valid_bob)).should == true
    users(:valid_bob).can_destroy?(users(:valid_bob)).should == true
  end

  it "non-admin others can't update or destroy" do
    users(:valid_huang).can_update?(users(:valid_bob)).should == false
    users(:valid_huang).can_destroy?(users(:valid_bob)).should == false
  end

  it "admin can update super_admin field if it has changed" do
    user_with_admin_flag_modified = users(:valid_bob)
    user_with_admin_flag_modified.super_admin = true
    users(:admin).should be_can_update(user_with_admin_flag_modified)
  end

  it "admin can update super_admin field if it has NOT changed" do
    users(:admin).should be_can_update(users(:valid_bob))
  end

  it "non-admin cannot update super_admin field" do
    users(:valid_bob).should_not be_super_admin
    user_with_admin_flag_modified = users(:valid_bob)
    user_with_admin_flag_modified.should_not be_super_admin_changed
    user_with_admin_flag_modified.super_admin = true
    user_with_admin_flag_modified.should be_super_admin_changed
    user_with_admin_flag_modified.should_not be_can_update(user_with_admin_flag_modified)
  end

  it "non-admin others cannot update another user's super_admin field" do
    users(:valid_bob).should_not be_super_admin
    user_with_admin_flag_modified = users(:valid_bob)
    users(:valid_huang).should_not be_super_admin
    users(:valid_huang).should_not be_can_update(user_with_admin_flag_modified)
    user_with_admin_flag_modified.super_admin = true
    users(:valid_huang).should_not be_can_update(user_with_admin_flag_modified)
  end
end

describe User, 'change password' do
  it "should not allow the changing of password without current password if no password reset token is present" do
    users(:valid_bob).attributes = {:password => 'new_password', :password_confirmation => 'new_password'}
    users(:valid_bob).should_not be_valid
    users(:valid_bob).errors[:current_password].should_not be_nil
  end

  it "should allow the changing of password without current password if a password reset token is present" do
    users(:valid_bob).password_reset_tokens.create!
    users(:valid_bob).attributes = {:password => 'new_password', :password_confirmation => 'new_password'}
    users(:valid_bob).save!
    User.authenticate(:email_address => users(:valid_bob).email_address, :password => 'new_password').should == users(:valid_bob)
  end

  it "should allow the changing of password if the current_password is correct" do
    users(:valid_bob).attributes = {:current_password => 'password', :password => 'new_password', :password_confirmation => 'new_password'}
    users(:valid_bob).save!
    User.authenticate(:email_address => users(:valid_bob).email_address, :password => 'new_password').should == users(:valid_bob)
  end

  it "should not allow the changing of password if the current_password is incorrect" do
    users(:valid_bob).attributes = {:current_password => 'incorrect', :password => 'new_password', :password_confirmation => 'new_password'}
    users(:valid_bob).should_not be_valid
    users(:valid_bob).errors[:current_password].should_not be_nil
    User.authenticate(:email_address => users(:valid_bob).email_address, :password => 'new_password').should be_nil
  end
end

describe User, 'email_address' do
  it "should save email_address when updated" do
    email_address = "new_email_address@foo.bar"
    users(:valid_bob).email_address = email_address
    users(:valid_bob).save!
    users(:valid_bob).reload.email_address.should == email_address
  end

  it "should create email address when set" do
    user = new_user(:email_address => email_address = 'new_email@foo.bar')
    user.save!
    user.reload.email_address.should == email_address
  end
end

describe User, "Associations" do

  it "should cascade delete to logins" do
    login = Login.create(:email_address => 'valid_bob', :password => 'password')
    Login.find_with_deleted(login.id).deleted_at.should be_nil
    user = users(:valid_bob)
    login.user.should == user
    user.destroy
    Login.find_with_deleted(login.id).deleted_at.should_not be_nil
  end

  it "should cascade delete to password_reset_tokens" do
    token = tokens(:password_reset_token)
    user = users(:valid_huang)
    token.tokenable.should == user
    user.destroy
    Token.find_by_id(token.id).should be_nil
  end

  it "should cascade delete to email_addresses" do
    email_address = email_addresses(:valid_bob_primary)
    user = users(:valid_bob)
    email_address.user.should == user
    user.destroy
    EmailAddress.find_by_id(email_address.id).should be_nil
  end

  it "should cascade delete to profile" do
    profile = profiles(:for_valid_user)
    user = users(:valid_bob)
    profile.user.should == user
    user.destroy
    Profile.find_by_id(profile.id).should be_nil
  end
end

describe User, 'Validations' do
  it "should generate a GUID if the user does not specify a unique_name" do
    user = new_user(:unique_name => '')
    user.save!
    user.reload
    user[:unique_name].should_not be_blank
  end

  it "should validate uniqueness of unique_name" do
    user1 = new_user(:unique_name => 'theonlyone')
    user1.save!
    user2 = new_user(:unique_name => 'theonlyone')
    user2.save
    user2.errors[:unique_name].should_not be_nil
  end
end

describe User, 'Finders' do
  it "#find_by_param should find based on unique_name" do
    user = users(:valid_bob)
    User.find_by_param(user.unique_name).should == user
  end
end

describe User, 'to_param' do
  it "should return the value of unique_name" do
    users(:valid_bob).to_param.should == users(:valid_bob).unique_name
  end
end