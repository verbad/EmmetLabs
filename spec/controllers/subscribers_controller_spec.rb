require File.dirname(__FILE__) + '/../spec_helper'

describe SubscribersController, "handling pose" do

  it "should create a subscriber given a valid email address" do
    post :create, :subscriber => {:email_address => 'valid@valid.com'}, :format => 'js'
    assigns(:subscriber).should be_valid
    assigns(:subscriber).should_not be_new_record
    assigns(:subscriber).email_address.should == 'valid@valid.com'
  end

  it "should not create a subscriber given an invalid email address" do
    post :create, :subscriber => {:email_address => 'asjdi @ kasopdkqwdwd'}, :format => 'js'
    assigns(:subscriber).should_not be_valid
    assigns(:subscriber).should be_new_record
  end

end
