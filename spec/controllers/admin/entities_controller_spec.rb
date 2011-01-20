require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::EntitiesController, "in general" do
  it "should be an admin controller" do
    controller.is_a?(Admin::AdminController).should be_true
  end
end

describe Admin::EntitiesController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end

describe Admin::EntitiesController, "index" do
  it "GET 'index' should be successful" do
    log_in(:david)
    get :index
    response.should be_success
  end
end

describe Admin::EntitiesController do
  it_should_behave_like 'login'

  describe "handling GET /entities" do

    before(:each) do
      @entity = Entity.new(:full_name => %q{Pandora's box})
      Entity.stub!(:find).and_return([@entity])
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

    it "should find all entities" do
      Entity.should_receive(:find).with(:all).any_number_of_times.and_return([@entity])
      do_get
    end

    it "should assign the found entities for the view" do
      do_get
      assigns[:entities].should == [@entity]
    end
  end

  describe "handling GET /admin/entities/Lipstick_1" do

    before(:each) do
      @entity = entities(:lipstick)
      Entity.stub!(:find).and_return(@entity)
    end
  
    def do_get
      get :show, :id => "Lipstick_1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the entity requested" do
      Entity.should_receive(:find_by_param).with("Lipstick_1").and_return(@entity)
      do_get
    end
  
    it "should assign the found entity for the view" do
      do_get
      assigns[:entity].should == (@entity)
    end
  end

  describe "handling DELETE /entities/Lipstick_1" do
    before do
      @entity = entities(:lipstick)
      Entity.stub!(:find_by_param).and_return(@entity)
    end
  
    def do_delete
      # pending("DELETE is not yet implemented")
      delete :destroy, :id => @entity.to_param
    end

    it "should find the entity requested" do
      Entity.should_receive(:find_by_param).with(@entity.to_param).and_return(@entity)
      do_delete
    end
  
    it "should call destroy on the found entity" do
      @entity.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the entities list" do
      do_delete
      response.should redirect_to(admin_entities_url)
    end
  end  
end



