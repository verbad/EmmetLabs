require File.dirname(__FILE__) + '/../spec_helper'

describe TermsOfService, "when there are tos in the db" do
  before do
    @tos_rev_2 = TermsOfService.create!(:text => 'xxx')
    @tos_rev_3 = TermsOfService.create!(:text => 'yyy')
  end
  
  it "should have fixtures with a text and revision" do

    @tos_rev_2.text.should_not be_nil
    @tos_rev_3.text.should_not be_nil

    @tos_rev_2.revision.should == 1
    @tos_rev_3.revision.should == 2
  end
  
  it "should return the latest terms of service" do
    TermsOfService.latest.revision.should == @tos_rev_3.revision
  end
  
  it "should create with incremented revision" do
    previous_revision = TermsOfService.latest.revision
    tos = TermsOfService.create!(:text => 'zzz')
    tos.text.should == 'zzz'
    TermsOfService.latest.revision.should == (previous_revision + 1)
  end
  
  it "should not create with no text" do
    tos = TermsOfService.create
    tos.should_not be_valid
  end

  it 'should be readable by non super admin' do
    non_admin_user = users(:valid_bob)
    non_admin_user.can_read?(TermsOfService.new).should == true
  end

  it 'should be readable by super admin' do
    admin_user = users(:admin)
    admin_user.can_read?(TermsOfService.new).should == true
  end

  it 'should not be creatable by non super admin' do
    non_admin_user = users(:valid_bob)
    non_admin_user.can_create?(TermsOfService.new).should == false
  end

  it 'should be creatable by super admin' do
    admin_user = users(:admin)
    admin_user.can_create?(TermsOfService.new).should == true
  end

  it "should return false for .latest? when passed in nil" do
    TermsOfService.should_not be_latest(nil)
  end

  it "should return false for .latest? when passed in wrong value" do
    TermsOfService.should_not be_latest(@tos_rev_2)
  end

  it "should return true for .latest? when passed in right value" do
    TermsOfService.should be_latest(@tos_rev_3)
  end

  it "should return true for defined?" do
    TermsOfService.defined?.should be_true
  end

end

describe TermsOfService, "when there is no tos in the db" do

  before(:each) do
    TermsOfService.delete_all
  end

  it "should return true for latest? when passed in nil" do
    TermsOfService.should be_latest(nil)
  end

  it "should return nil for latest" do
    TermsOfService.latest.should be_nil
  end

  it "should return false for defined?" do
    TermsOfService.defined?.should be_false
  end

end