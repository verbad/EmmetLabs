require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::RelationshipsController, "in general" do
  it "should be an admin controller" do
    controller.is_a?(Admin::AdminController).should be_true
  end
end

describe Admin::RelationshipsController, "index" do
  it "GET 'index' should be successful" do
    log_in(:david)
    get :destroy, :id => 1
    response.should be_success
  end
end

describe Admin::RelationshipsController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end

describe Admin::RelationshipsController do
  it_should_behave_like 'login'

  describe "handling DELETE /admin/relationships/1" do

    before(:each) do
      @relationship = relationships(:janis_and_jim)
      Relationship.stub!(:find).and_return(@relationship)
    end
  
    def do_delete
      delete :destroy, :id => "1" 
    end

    it "should find the relationship requested" do
      Relationship.should_receive(:find).with("1").and_return(@relationship)
      do_delete
    end
  
    it "should call destroy on the found relationship" do
      @relationship.should_receive(:destroy)
      do_delete
    end
  
  end
end
