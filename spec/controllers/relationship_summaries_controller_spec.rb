require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipSummariesController, "handling put" do
  it_should_behave_like 'login'

  before do
    @relationship = relationships(:grace_and_josephine)
  end

  it "should update the summary for a relationship" do
    put :update, :relationship_id => @relationship.to_param, :id => @relationship.to_param, :relationship => { :summary => 'a new summary!'}, :format => 'js'
    response.should be_success
    
    @relationship.reload
    @relationship.summary.should == 'a new summary!'
  end
end

describe RelationshipSummariesController do
  it "should require login" do
    get :index, :relationship_id => relationships(:grace_and_josephine).to_param
    response.response_code.should == 302
  end
end
