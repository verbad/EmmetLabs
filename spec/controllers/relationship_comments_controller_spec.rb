require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipCommentsController do
  it_should_behave_like 'login'
  
  before do
    @relationship = relationships(:grace_and_josephine)
  end

  it "should handle successful create" do
    initial_count = @relationship.comments.size
    post :create, :relationship_id => @relationship.id, :comment => {:text=>'a new comment'}
    assigns(:relationship).comments.last.errors.should be_empty    
    @relationship.comments(true)
    @relationship.comments.size.should == initial_count + 1
    @relationship.comments.last.text.should == 'a new comment'
  end

  it "should handle unsuccessful create" do
    initial_count = @relationship.comments.size
    post :create, :relationship_id => @relationship.id, :comment => {:text=>''}
    assigns(:relationship).comments.last.errors.should_not be_empty
    @relationship.comments(true)
    @relationship.comments.size.should == initial_count
  end

end

describe RelationshipCommentsController do
  it "should require login" do
    post :create, :relationship_id => relationships(:grace_and_josephine).id
    response.response_code.should == 302
  end
end