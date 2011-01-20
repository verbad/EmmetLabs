require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PeopleController, "in general" do
  it "should be an admin controller" do
    controller.is_a?(Admin::AdminController).should be_true
  end
end

describe Admin::PeopleController, "index" do
  it "GET 'index' should be successful" do
    log_in(:david)
    get :index
    response.should be_success
  end
end

describe Admin::PeopleController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end

describe Admin::PeopleController do
  it_should_behave_like 'login'

  describe "handling GET /people" do

    before(:each) do
      @person = Person.new(:first_name => 'first', :last_name => 'last')
      Person.stub!(:find).and_return([@person])
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

    it "should find all people" do
      Person.should_receive(:find).with(:all).any_number_of_times.and_return([@person])
      do_get
    end

    it "should assign the found people for the view" do
      do_get
      assigns[:people].should == [@person]
    end
  end

  describe "handling GET /admin/people/Janis-Joplin_1" do

    before(:each) do
      @person = people(:janis)
      Person.stub!(:find).and_return(@person)
    end
  
    def do_get
      get :show, :id => "Janis-Joplin_1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the person requested" do
      Person.should_receive(:find_by_param).with("Janis-Joplin_1").and_return(@person)
      do_get
    end
  
    it "should assign the found person for the view" do
      do_get
      assigns[:person].should == (@person)
    end
  end

  describe "handling DELETE /people/Janis-Joplin_1" do

    before do
      @person = people(:janis)
      Person.stub!(:find_by_param).and_return(@person)
    end
  
    def do_delete
      delete :destroy, :id => @person.to_param
    end

    it "should find the person requested" do
      Person.should_receive(:find_by_param).with(@person.to_param).and_return(@person)
      do_delete
    end
  
    it "should call destroy on the found person" do
      @person.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the people list" do
      do_delete
      response.should redirect_to(admin_people_url)
    end
  end
  
  describe "handling migrate_to_entity" do
    before do
      @person = people(:janis)
      @entity = entities(:lipstick)
      Person.stub!(:find_by_param).and_return(@person)
    end
    
    it "should migrate and redirect" do
      post :migrate_to_entity, :id => @person.to_param
      response.should be_redirect
    end
    
    it "should find the person requested" do
      Person.should_receive(:find_by_param).with(@person.to_param).and_return(@person)
      post :migrate_to_entity, :id => @person.to_param
    end
    
    it "should create an entity from the person" do
      Entity.should_receive(:migrate_from_person!).with(@person).and_return(@entity)
      post :migrate_to_entity, :id => @person.to_param
    end
    
    it "should destroy the person" do
      Person.should_receive(:find_by_param).with(@person.to_param).and_return(@person)
      @person.should_receive(:destroy)
      post :migrate_to_entity, :id => @person.to_param
    end
  end
end
