require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipsController do
  it_should_behave_like 'login'
  
  before do
    @relationship = relationships(:grace_and_josephine)
  end
  
  it "handles edit action" do
    get :edit, :id => @relationship.to_param
    response.should be_success
    assigns[:relationship].should == @relationship
    
    assigns[:related_people].should include(people(:grace))
    assigns[:related_people].should include(people(:josephine))
   end

  it "handles update action" do
    @relationship.photos.should be_empty
    put :update, :id => @relationship.to_param, :relationship => {:photo => fixture_file_upload("/photo.png", 'image/png')}
    response.response_code.should == 302
    @relationship.reload
    @relationship.photos.should_not be_empty
  end
end

describe RelationshipsController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end