require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ViewersController do
  it_should_behave_like 'login'

  it "should use ViewersController" do
    controller.should be_an_instance_of(ViewersController)
  end
  
  describe "route generation" do
    it "should map { :controller => 'viewers', :action => 'show', :node_type => 'entities', :id => 'entity_id'} to /view/entities/entity_id" do
      route_for(:controller => "viewers", :action => "show", :node_type => 'entities', :id => 'entity_id').should == "/view/entities/entity_id"
    end
  end

  describe "GET 'show'" do
    before do
      @person = people(:janis)
    end
    
    it "should be successful with a person" do
      get 'show', :node_type => @person.class.name.tableize, :id => @person.to_param
      response.should be_success
    end
    
    it "should call resolve_categories" do
      controller.should_receive(:resolve_categories)
      get 'show', :node_type => @person.class.name.tableize, :id => @person.to_param
    end
    
    it "should raise ActiveRecord::RecordNotFound when no entity is found" do
      lambda { 
        get 'show', :node_type => @person.class.name.tableize, :id => 'does-not-exist'
      }.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should reload the entity's photos" do
      pending("Testing associations is hard, and we don't now why we are calling reload anyway...")
      Person.stub!(:find_by_param).and_return(@person)
      @person.stub!(:photos)

      @mock_photo = mock("Photo") # mocked association
      @mock_photo.should_receive(:reload)
      @person.should_receive(:photos).and_return(@mock_photos)
      
      get 'show', :node_type => @person.class.name.tableize, :id => @person.to_param
    end
  end
end
