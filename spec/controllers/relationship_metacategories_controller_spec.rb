require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipMetacategoriesController, "#route_for" do
  it_should_behave_like 'login'

  it "should map { :controller => 'relationship_metacategories', :action => 'index' } to /relationship_metacategories" do
    route_for(:controller => "relationship_metacategories", :action => "index").should == "/relationship_metacategories"
  end
  
  it "should map { :controller => 'relationship_metacategories', :action => 'new' } to /relationship_metacategories/new" do
    route_for(:controller => "relationship_metacategories", :action => "new").should == "/relationship_metacategories/new"
  end
  
  it "should map { :controller => 'relationship_metacategories', :action => 'show', :id => 1 } to /relationship_metacategories/1" do
    route_for(:controller => "relationship_metacategories", :action => "show", :id => 1).should == "/relationship_metacategories/1"
  end
  
  it "should map { :controller => 'relationship_metacategories', :action => 'edit', :id => 1 } to /relationship_metacategories/1/edit" do
    route_for(:controller => "relationship_metacategories", :action => "edit", :id => 1).should == "/relationship_metacategories/1/edit"
  end
  
  it "should map { :controller => 'relationship_metacategories', :action => 'update', :id => 1} to /relationship_metacategories/1" do
    route_for(:controller => "relationship_metacategories", :action => "update", :id => 1).should == "/relationship_metacategories/1"
  end
  
  it "should map { :controller => 'relationship_metacategories', :action => 'destroy', :id => 1} to /relationship_metacategories/1" do
    route_for(:controller => "relationship_metacategories", :action => "destroy", :id => 1).should == "/relationship_metacategories/1"
  end
  
end

describe RelationshipMetacategoriesController, "handling GET /relationship_metacategories" do
  it_should_behave_like 'login'

  before do
    @relationship_metacategory = relationship_metacategories(:family)
    RelationshipMetacategory.stub!(:find).and_return([@relationship_metacategory])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all relationship_metacategories" do
    RelationshipMetacategory.should_receive(:find).with(:all).and_return([@relationship_metacategory])
    do_get
  end
  
  it "should assign the found relationship_metacategories for the view" do
    do_get
    assigns[:relationship_metacategories].should == [@relationship_metacategory]
  end
end


describe RelationshipMetacategoriesController, "handling GET /relationship_metacategories/new" do
  it_should_behave_like 'login'

  before do
    @relationship_metacategory = relationship_metacategories(:family)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end  
end

describe RelationshipMetacategoriesController, "handling GET /relationship_metacategories/1/edit" do
  it_should_behave_like 'login'

  before do
    @relationship_metacategory = relationship_metacategories(:family)
  end
  
  def do_get
    get :edit, :id => @relationship_metacategory.to_param
  end

  it "should be successful" do
    do_get
    response.should be_success
  end  
end

describe RelationshipMetacategoriesController, "handling POST /relationship_metacategories" do
  it_should_behave_like 'login'

  it "should create a new relationship_metacategory" do
    pre_create_count = RelationshipMetacategory.count
    post :create, :relationship_metacategory => { :name => 'coworkers' }    
    RelationshipMetacategory.count.should == pre_create_count + 1    
    response.should redirect_to(relationship_metacategories_url)
  end
end

describe RelationshipMetacategoriesController, "handling PUT /relationship_metacategories/1" do
  it_should_behave_like 'login'

  before do
    @relationship_metacategory = relationship_metacategories(:family)
  end
  
  it "should update the metacategory" do
    @relationship_metacategory.name.should_not == 'moo'
    
    put :update, :id => @relationship_metacategory.to_param, :relationship_metacategory => {:name => 'moo'}
    
    @relationship_metacategory.reload
    @relationship_metacategory.name.should == 'moo'
    assigns(:relationship_metacategory).should == @relationship_metacategory
    
    response.should redirect_to(relationship_metacategories_url)
  end
end

describe RelationshipMetacategoriesController, "handling DELETE /relationship_metacategories/1" do
  it_should_behave_like 'login'

  before do
    @relationship_metacategory = mock_model(RelationshipMetacategory, :destroy => true)
    RelationshipMetacategory.stub!(:find).and_return(@relationship_metacategory)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the relationship_metacategory requested" do
    RelationshipMetacategory.should_receive(:find).with("1").and_return(@relationship_metacategory)
    do_delete
  end
  
  it "should call destroy on the found relationship_metacategory" do
    @relationship_metacategory.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the relationship_metacategories list" do
    do_delete
    response.should redirect_to(relationship_metacategories_url)
  end
end

describe RelationshipMetacategoriesController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end