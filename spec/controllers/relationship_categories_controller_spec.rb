require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipCategoriesController, "#route_for" do
  it_should_behave_like 'login'

  it "should map { :controller => 'relationship_categories', :action => 'index' } to /relationship_categories" do
    route_for(:controller => "relationship_categories", :action => "index").should == "/relationship_categories"
  end
  
  it "should map { :controller => 'relationship_categories', :action => 'new' } to /relationship_categories/new" do
    route_for(:controller => "relationship_categories", :action => "new").should == "/relationship_categories/new"
  end
  
  it "should map { :controller => 'relationship_categories', :action => 'show', :id => 1 } to /relationship_categories/1" do
    route_for(:controller => "relationship_categories", :action => "show", :id => 1).should == "/relationship_categories/1"
  end
  
  it "should map { :controller => 'relationship_categories', :action => 'edit', :id => 1 } to /relationship_categories/1/edit" do
    route_for(:controller => "relationship_categories", :action => "edit", :id => 1).should == "/relationship_categories/1/edit"
  end
  
  it "should map { :controller => 'relationship_categories', :action => 'update', :id => 1} to /relationship_categories/1" do
    route_for(:controller => "relationship_categories", :action => "update", :id => 1).should == "/relationship_categories/1"
  end
  
  it "should map { :controller => 'relationship_categories', :action => 'destroy', :id => 1} to /relationship_categories/1" do
    route_for(:controller => "relationship_categories", :action => "destroy", :id => 1).should == "/relationship_categories/1"
  end
  
end

describe RelationshipCategoriesController, "handling GET /relationship_categories" do
  it_should_behave_like 'login'

  before do
  end
  
  def do_get

  end
  
  it "should be successful" do
    get :index    
    response.should be_success
  end
end

describe RelationshipCategoriesController, "handling GET /relationship_categories.xml" do
  it_should_behave_like 'login'

  before do
    @relationship_category = mock_model(RelationshipCategory, :to_xml => "XML")
    RelationshipCategory.stub!(:find).and_return(@relationship_category)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all relationship_categories" do
    RelationshipCategory.should_receive(:find).with(:all).and_return([@relationship_category])
    do_get
  end
  
  it "should render the found relationship_categories as xml" do
    @relationship_category.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe RelationshipCategoriesController, "handling GET /relationship_categories/new" do
  it_should_behave_like 'login'

  it "should be successful" do
    get :new
    response.should be_success
  end  
end

describe RelationshipCategoriesController, "handling GET /relationship_categories/1/edit" do
  it_should_behave_like 'login'

  before do
    @relationship_category = relationship_categories(:friend)
  end
  
  it "should be successful" do
    get :edit, :id => @relationship_category.to_param 
    response.should be_success
    
    assigns[:relationship_category].should  == @relationship_category
    assigns[:relationship_categories].should  == RelationshipCategory.symmetric
  end
end

describe RelationshipCategoriesController, "handling POST /relationship_categories" do
  it_should_behave_like 'login'

  it "should create a new relationship_category" do
    pre_create_count = RelationshipCategory.count
    post :create, :relationship_category =>  { :name => 'coworkers', :metacategory_id => 1 }  
    response.should redirect_to(relationship_categories_url)
    RelationshipCategory.count.should == pre_create_count + 1
  end
end

describe RelationshipCategoriesController, "handling PUT /relationship_categories/1" do
  it_should_behave_like 'login'

  before do
    @relationship_category = relationship_categories(:child)
  end
  
  it "should update relationship_category requested" do
    @relationship_category.name.should_not == 'moo'
    put :update, :id => @relationship_category.to_param, :relationship_category => {:name => 'moo'}
    @relationship_category.reload
    @relationship_category.name.should == 'moo'
    response.should redirect_to(relationship_categories_url)
  end

  
end

describe RelationshipCategoriesController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end
