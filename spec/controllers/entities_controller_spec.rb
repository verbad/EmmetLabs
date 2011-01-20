require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EntitiesController, "#route_for" do
  it_should_behave_like 'login'
  it "should map { :controller => 'entities', :action => 'index' } to /entities" do
    route_for(:controller => "entities", :action => "index").should == "/entities"
  end

  it "should map { :controller => 'entities', :action => 'new' } to /entities/new" do
    route_for(:controller => "entities", :action => "new").should == "/entities/new"
  end
  
  it "should map { :controller => 'entities', :action => 'show', :id => 1 } to /entities/1" do
    route_for(:controller => "entities", :action => "show", :id => 1).should == "/entities/1"
  end

  it "should map { :controller => 'entities', :action => 'update', :id => 1} to /entities/1" do
    route_for(:controller => "entities", :action => "update", :id => 1).should == "/entities/1"
  end
end

describe EntitiesController do
  it "should require login" do
    get :show, :id => entities(:lipstick).to_param
    response.response_code.should == 302
  end
end

describe EntitiesController, "handling /stories/new" do
  it_should_behave_like 'login'
  def do_get
    pending("Entities can't be created yet")
    get :new
  end
  
  describe "without additional params" do
    before do
      do_get
    end
    
    it "should respond successfully" do
      response.should be_success
    end
    
    it "should render the 'new' template" do
      response.should render_template('new')
    end
  
    it "should assign a new Entity instance to @entity" do
      assigns[:entity].should be_new_record
    end
  end
  
  it "should assign a new Entity instance to @entity with name from params[:query]" do
    pending("Entities can't be created yet")
    get :new, :query => "Pandora's Box"
    assigns[:entity].should be_new_record
    assigns[:entity].full_name.should == "Pandora's Box"
  end
end

describe EntitiesController, "handling POST /entities/create" do
  it_should_behave_like 'login'
  
  it "should capture author_id when creating a new entity" do
    pending("Entities can't be created yet")
    post :create, :format => 'html',
      :entity => { :full_name => "Pandora's Box", :summary => 'text'}

    entity = assigns(:entity)
    entity.should_not be_new_record
    entity.author_id.should == users(:janice).id
  end

  it "should handle errors" do
    pending("Entities can't be created yet")
    # TODO Revisit once not pending
    post :create, :format => 'js',
      :entity => { :first_name => 'Joe', :last_name => 'Smith', :common_name => 'Joey'},
      :birth => {:month => '4', :year => 'Year', :name => 'a barn', :type_id => Milestone::Type[:birth].id},
      :death => {:month => '', :year => 'Year', :name => '', :type_id => Milestone::Type[:death].id}

    response.should be_success
    response.should render_template('create')
    entity = assigns(:entity)
    entity.should be_new_record
    entity.birth_milestone.year.should be_nil
    entity.birth_milestone.month.should == 4
    entity.birth_milestone.name.should == 'a barn'
    entity.birth_milestone.day.should be_nil
    entity.birth_milestone.errors.should_not be_empty
  end

end

describe EntitiesController, "handling update" do
  it_should_behave_like 'login'

  it "should go back to edit mode when you have an invalid update" do
    put :update, :format => 'js',
      :id => entities(:lipstick).to_param,
      # Summary longer than 150 chars
      :entity => { :full_name => 'Lipstick', :summary => 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aliquam ac leo id odio tincidunt tempus. Nam vestibulum erat congue risus. Phasellus sodales sed.'}

    response.should be_success
    response.should render_template('create')
    assigns(:edit).should be_true
  end
  
end
