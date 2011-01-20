require File.dirname(__FILE__) + '/../spec_helper'

describe PeopleController, "#route_for" do
  it_should_behave_like 'login'
  it "should map { :controller => 'people', :action => 'index' } to /people" do
    route_for(:controller => "people", :action => "index").should == "/people"
  end

  it "should map { :controller => 'people', :action => 'new' } to /people/new" do
    route_for(:controller => "people", :action => "new").should == "/people/new"
  end
  
  it "should map { :controller => 'people', :action => 'show', :id => 1 } to /people/1" do
    route_for(:controller => "people", :action => "show", :id => 1).should == "/people/1"
  end

  it "should map { :controller => 'people', :action => 'update', :id => 1} to /people/1" do
    route_for(:controller => "people", :action => "update", :id => 1).should == "/people/1"
  end
end

describe PeopleController, "handling /stories/new" do
  it_should_behave_like 'login'
  
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
  
    it "should assign a new Person instance to @person" do
      get :new
      assigns[:person].should be_new_record
    end
  end
  
  it "should assign a new Person instance to @person with name from params[:query]" do
    get :new, :query => 'John Smith'
    assigns[:person].should be_new_record
    assigns[:person].full_name.should == 'John Smith'
  end
end

describe PeopleController, "handling POST /people/create" do
  it_should_behave_like 'login'
  
  it "should capture author_id when creating a new person" do
    post :create, :format => 'html',
      :person => { :first_name => 'Joe', :last_name => 'Smith', :common_name => 'Joey', :summary => 'text'}

    person = assigns(:person)
    person.should_not be_new_record
    person.author_id.should == users(:janice).id
  end

  it "should create a new person with birth and death milestones" do
    post :create, :format => 'js',
      :person => { :first_name => 'Joe', :last_name => 'Smith', :common_name => 'Joey', :summary => 'text'},
      :birth => {:month => '4', :year => '1900', :name => 'a barn', :type_id => Milestone::Type[:birth].id},
      :death => {:month => '', :year => 'YYYY', :name => '', :type_id => Milestone::Type[:death].id}

    response.should be_success
    response.should render_template('create')
    person = assigns(:person)
    person.should_not be_new_record
    person.first_name.should == 'Joe'
    person.last_name.should == 'Smith'
    person.common_name.should == 'Joey'
    person.birth_milestone.year.should == 1900
    person.birth_milestone.month.should == 4
    person.birth_milestone.day.should be_nil
    person.birth_milestone.name.should == 'a barn'
    person.death_milestone.should be_nil
  end

  it "should handle errors" do
    pending("Obsolete spec. Should be handled by EntityAttributesController instead.")
    post :create, :format => 'js',
      :person => { :first_name => 'Joe', :last_name => 'Smith', :common_name => 'Joey'},
      :birth => {:month => '4', :year => 'YYYY', :name => 'a barn', :type_id => Milestone::Type[:birth].id},
      :death => {:month => '', :year => 'YYYY', :name => '', :type_id => Milestone::Type[:death].id}

    response.should be_success
    response.should render_template('create')
    person = assigns(:person)
    person.should be_new_record
    person.birth_milestone.year.should be_nil
    person.birth_milestone.month.should == 4
    person.birth_milestone.name.should == 'a barn'
    person.birth_milestone.day.should be_nil
    person.birth_milestone.errors.should_not be_empty
  end

end

describe PeopleController, "handling update" do
  it_should_behave_like 'login'

  it "should go back to edit mode when you have an invalid update" do
    pending("Obsolete spec. Should be handled by EntityAttributesController instead.")
    put :update, :format => 'js',
      :id => people(:josephine).to_param,
      :person => { :first_name => 'Joe', :last_name => 'Smith', :common_name => 'Joey', :summary => ''},
      :birth => {:month => '4', :year => '1900', :name => 'a barn', :type_id => Milestone::Type[:birth].id},
      :death => {:month => '', :year => 'YYYY', :name => '', :type_id => Milestone::Type[:death].id}

    response.should be_success
    response.should render_template('create')
    assigns(:edit).should be_true
  end
  
end


describe PeopleController do
  it "should require login" do
    get :show, :id => people(:josephine).to_param
    response.response_code.should == 302
  end
end