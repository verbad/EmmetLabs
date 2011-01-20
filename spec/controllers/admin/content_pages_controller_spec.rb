require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ContentPagesController, "in general" do
  it "should be an admin controller" do
    controller.is_a?(Admin::AdminController).should be_true
  end
end

describe Admin::ContentPagesController, "index" do
  it "GET 'index' should be successful" do
    log_in(:david)
    get :index
    response.should be_success
  end
end

describe Admin::ContentPagesController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end


describe Admin::ContentPagesController do
  it_should_behave_like 'login'

  describe "handling GET /content_pages" do

    before(:each) do
      @content_page = ContentPage.new(:name => 'new content page')
      ContentPage.stub!(:find).and_return([@content_page])
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

    it "should find all content_pages" do
      ContentPage.should_receive(:find).with(:all).any_number_of_times.and_return([@content_page])
      do_get
    end

    it "should assign the found content_pages for the view" do
      do_get
      assigns[:content_pages].should == [@content_page]
    end
  end

  describe "handling GET /content_pages/1" do

    before(:each) do
      @content_page = content_pages(:guidelines)
      ContentPage.stub!(:find).and_return(@content_page)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the content_page requested" do
      ContentPage.should_receive(:find).with("1").and_return(@content_page)
      do_get
    end
  
    it "should assign the found content_page for the view" do
      do_get
      assigns[:content_page].should equal(@content_page)
    end
  end

  describe "handling GET /content_pages/new" do

    before(:each) do
      @content_page = mock_model(ContentPage)
      ContentPage.stub!(:new).and_return(@content_page)
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
  
    it "should create an new content_page" do
      ContentPage.should_receive(:new).and_return(@content_page)
      do_get
    end
  
    it "should not save the new content_page" do
      @content_page.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new content_page for the view" do
      do_get
      assigns[:content_page].should equal(@content_page)
    end
  end

  describe "handling GET /content_pages/1/edit" do

    before(:each) do
      @content_page = mock_model(ContentPage)
      ContentPage.stub!(:find).and_return(@content_page)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the content_page requested" do
      ContentPage.should_receive(:find).twice.and_return(@content_page)
      do_get
    end
  
    it "should assign the found ContentPage for the view" do
      do_get
      assigns[:content_page].should equal(@content_page)
    end
  end

  describe "handling POST /content_pages" do

    before(:each) do
      @content_page = mock_model(ContentPage, :to_param => "1")
      ContentPage.stub!(:new).and_return(@content_page)
    end
    
    describe "with successful save" do
  
      def do_post
        @content_page.should_receive(:save).and_return(true)
        post :create, :content_page => {}
      end
  
      it "should create a new content_page" do
        ContentPage.should_receive(:new).with({}).and_return(@content_page)
        do_post
      end

      it "should redirect to the new content_page" do
        do_post
        response.should redirect_to(admin_content_page_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @content_page.should_receive(:save).and_return(false)
        post :create, :content_page => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /content_pages/1" do

    before(:each) do
      @content_page = mock_model(ContentPage, :to_param => "1")
      ContentPage.stub!(:find).and_return(@content_page)
    end
    
    describe "with successful update" do

      def do_put
        @content_page.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the content_page requested" do
        ContentPage.should_receive(:find).with("1").and_return(@content_page)
        do_put
      end

      it "should update the found content_page" do
        do_put
        assigns(:content_page).should equal(@content_page)
      end

      it "should assign the found content_page for the view" do
        do_put
        assigns(:content_page).should equal(@content_page)
      end

      it "should redirect to the content_page" do
        do_put
        response.should redirect_to(admin_content_page_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @content_page.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /content_pages/1" do

    before(:each) do
      @content_page = mock_model(ContentPage, :destroy => true)
      ContentPage.stub!(:find).and_return(@content_page)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the content_page requested" do
      ContentPage.should_receive(:find).with("1").and_return(@content_page)
      do_delete
    end
  
    it "should call destroy on the found content_page" do
      @content_page.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the content_pages list" do
      do_delete
      response.should redirect_to(admin_content_pages_url)
    end
  end
end
