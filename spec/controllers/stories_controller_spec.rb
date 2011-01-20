require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StoriesController do
  it_should_behave_like 'login'
  
  it "should use StoriesController" do
    controller.should be_an_instance_of(StoriesController)
  end
  
  describe "#route_for" do
    it "should map {:controller => 'stories', :action => 'new'} to /stories/new" do
      route_for(:controller => "stories", :action => "new").should == "/stories/new"
    end
    
    it "should map {:controller => 'stories', :action => 'create'} to /stories" do
      route_for(:controller => "stories", :action => "create").should == "/stories"
    end
  end
  
  describe "handling /stories/new" do
    before do
      @person = mock('Person')
      @id = 1
      @name = 'Janice Joplin'
      @dashified = @name.gsub(' ', '-')
      Person.stub!(:new).and_return(@person)
      @person.stub!(:id).and_return(@id)
      @person.stub!(:name).and_return(@name)
      @person.stub!(:calculated_dashified_full_name).and_return(@dashified)
      
      @entity = mock('Entity')
      Entity.stub!(:new).and_return(@entity)
      @entity.stub!(:id).and_return(@id)
    end
    
    describe "without additional params" do
      before do
        get :new
      end
      
      it "should respond successfully" do
        response.should be_success
      end
      
      it "should render the 'new' template" do
        response.should render_template('new')
      end
    
      it "should not assign a Person instance to @person" do
        get :new
        assigns[:person].should be_nil
      end
    end
    
    it "should make a new Person with name based on the params[:query]" do
      Person.should_receive(:from_string).with(@name).and_return(@person)
      get :new, :query => @name
      assigns[:node].should == @person
    end
    
    it "should assign an existing Person when params[:person_id] is set" do
      param = "#{@dashified}_#{@id}"
      Person.should_receive(:find_by_param).with(param).and_return(@person)
      Person.should_not_receive(:from_string)
      get :new, :person_id => param
      assigns[:node].should == @person
    end
    
    it "should assign an existing Entity when params[:entity_id] is set" do
      param = "#{@dashified}_#{@id}"
      Entity.should_receive(:find_by_param).with(param).and_return(@entity)
      Entity.should_not_receive(:from_string)
      get :new, :entity_id => param
      assigns[:node].should == @entity
    end
   
    it "should assign @first if params[:index] is set correctly" do
      get :new, :index => 'first'
      assigns[:first].should == true
    end
    
    it "should assign @relationship_categories" do
      @relationship_categories = [relationship_categories(:lover), relationship_categories(:student)]
      RelationshipCategory.should_receive(:find).with(:all).and_return(@relationship_categories)
      get :new
      assigns[:relationship_categories].should == @relationship_categories
    end
  end
end
