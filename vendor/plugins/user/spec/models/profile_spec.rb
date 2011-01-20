require File.dirname(__FILE__) + '/../spec_helper'

describe "A profile" do
  before(:each) do
    @profile = profiles(:for_valid_user)
  end

  it "can be edited by owner" do
    @profile.updatable_by?(users(:valid_bob)).should == true
  end

  it "returns false when user is not self" do
    @profile.updatable_by?(users(:valid_huang)).should == false
  end

  it "non-admin others can't update or destroy" do
    users(:valid_huang).can_update?(profiles(:for_valid_user)).should == false
    users(:valid_huang).can_destroy?(profiles(:for_valid_user)).should == false
  end

  it "has an age method which calculates age" do
    @profile.date_of_birth = 10.years.ago - 5.days
    @profile.age.should == 10
  end

  it "returns nil for the age when the date of birth is not known" do
    @profile.date_of_birth = nil
    @profile.age.should be_nil
  end

  it "returns 0 if you were born under one year ago" do
    @profile.date_of_birth = 1.day.ago
    @profile.age.should == 0
  end

end

describe User, "security: update and destroy" do
  it "admin can update and destroy" do
    users(:admin).can_update?(profiles(:for_valid_user)).should == true
    users(:admin).can_destroy?(profiles(:for_valid_user)).should == true
  end

  it "self can update and destroy" do
    users(:valid_bob).can_update?(profiles(:for_valid_user)).should == true
    users(:valid_bob).can_destroy?(profiles(:for_valid_user)).should == true
  end

  it "non-admin others can't update or destroy" do
    users(:valid_huang).can_update?(profiles(:for_valid_user)).should == false
    users(:valid_huang).can_destroy?(profiles(:for_valid_user)).should == false
  end

end