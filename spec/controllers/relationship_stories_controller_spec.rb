require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipStoriesController, "#route_for" do
  it_should_behave_like 'login'

  it "should map { :controller => 'relationship_stories', :action => 'new' } to /relationship_stories/new" do
    route_for(:controller => "relationship_stories", :action => "new").should == "/relationship_stories/new"
  end
  
  it "should map { :controller => 'relationship_stories', :action => 'edit', :id => 1 } to /relationship_stories/1/edit" do
    route_for(:controller => "relationship_stories", :action => "edit", :id => 1).should == "/relationship_stories/1/edit"
  end
  
  it "should map { :controller => 'relationship_stories', :action => 'update', :id => 1} to /relationship_stories/1" do
    route_for(:controller => "relationship_stories", :action => "update", :id => 1).should == "/relationship_stories/1"
  end
  
  it "should map { :controller => 'relationship_stories', :action => 'destroy', :id => 1} to /relationship_stories/1" do
    route_for(:controller => "relationship_stories", :action => "destroy", :id => 1).should == "/relationship_stories/1"
  end
  
end

describe RelationshipStoriesController, "handling GET /relationship_stories/new" do
  it_should_behave_like 'login'

  before do
    @relationship = relationships(:jfk_and_marilyn)
  end
  
  def do_get
    get :new, :relationship_id => @relationship.id.to_param
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new, unsaved relationship_story" do
    do_get
    assigns(:relationship_story).should be_new_record
    assigns(:relationship_story).relationship_id.should == @relationship.id
  end
end

describe RelationshipStoriesController, "handling GET /relationship_stories/1/edit" do
  it_should_behave_like 'login'

  before do
    @relationship_story = relationship_stories(:janis_and_jim_0)
    RelationshipStory.stub!(:find).and_return(@relationship_story)
  end
  
  def do_get
    get :edit, :id => @relationship_story.to_param
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the relationship_story requested" do
    RelationshipStory.should_receive(:find).and_return(@relationship_story)
    do_get
  end
  
  it "should assign the found RelationshipStory for the view" do
    do_get
    assigns[:relationship_story].should equal(@relationship_story)
  end
end

describe RelationshipStoriesController, "handling POST /relationship_stories" do
  it_should_behave_like 'login'

  before do
    @relationship_story = RelationshipStory.new(:relationship => relationships(:jim_and_marilyn))
    @params = {:relationship_id => relationships(:jim_and_marilyn).id}
  end
  
  def do_post
    post :create, :relationship_story => @params
  end
  
  it "should create a new relationship_story" do
    old_count = RelationshipStory.count

    do_post

    RelationshipStory.count.should == old_count + 1
  end

  it "should redirect to the edit relationship page when done" do
    do_post
    response.should redirect_to(edit_relationship_url(@relationship_story.relationship))
  end
end

describe RelationshipStoriesController, "handling PUT /relationship_stories/1" do
  it_should_behave_like 'login'

  before do
    @relationship_story = relationship_stories(:jim_and_marilyn_0)
  end
  
  def do_update
    put :update, :id => @relationship_story.id.to_param, :relationship_story => {:text => "new text"}
  end
  
  it "should find the relationship_story requested" do
    RelationshipStory.should_receive(:find).with(@relationship_story.id.to_param).and_return(@relationship_story)
    do_update
  end

  it "should update the found relationship_story" do
    do_update
    assigns(:relationship_story).should == @relationship_story
    assigns(:relationship_story).text.should == "new text"
  end

  it "should redirect to the relationship_story" do
    do_update
    directed_rel = @relationship_story.relationship.directed_relationships[0]
    response.should redirect_to(edit_relationship_url(directed_rel.relationship))
  end
end

describe RelationshipStoriesController, "handling DELETE /relationship_stories/1" do
  it_should_behave_like 'login'

  before do
    @relationship_story = relationship_stories(:jim_and_marilyn_0)
  end
  
  def do_delete
    delete :destroy, :id => @relationship_story.id.to_param
  end

  it "should call destroy on the found relationship_story" do
    do_delete
    RelationshipStory.find_by_id(@relationship_story.id).should be_nil
  end
  
  it "should redirect to the relationship_stories list" do
    do_delete    
    response.should redirect_to(edit_relationship_url(@relationship_story.relationship))
  end
end

describe RelationshipStoriesController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end