require File.dirname(__FILE__) + '/../spec_helper'


describe Admin::HomePageRelationshipsController, "in general" do
  it "should be an admin controller" do
    controller.is_a?(Admin::AdminController).should be_true
  end
end

describe Admin::HomePageRelationshipsController, "#show" do
  it "GET 'show' should be successful" do
    log_in(:david)
    get 'show'
    response.should be_success
  end
end

describe Admin::HomePageRelationshipsController do
  it "should require login" do
    get :show
    response.response_code.should == 302
  end
end


describe Admin::HomePageRelationshipsController do
  it_should_behave_like 'login'
  
  describe "handling GET /admin/home_page_relationships" do

    before(:each) do
      @home_page_relationship = HomePageRelationship.new(:directed_relationship_id => 1 )
      HomePageRelationship.stub!(:find).and_return(@home_page_relationship)
    end
  
    def do_get
      get :show
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render show template" do
      do_get
      response.should render_template('show')
    end

    it "should find home page relationship" do
      HomePageRelationship.should_receive(:find).once.and_return(@home_page_relationship)
      do_get
    end

    it "should assign the home page relationship for the view" do
      do_get
      assigns[:home_page_relationship].should == @home_page_relationship
    end
  end
  
  describe "handling GET /admin/home_page_relationships/edit" do

    before(:each) do
      @home_page_relationship = HomePageRelationship.new(:directed_relationship_id => 1 )
      HomePageRelationship.stub!(:find).and_return(@home_page_relationship)
    end
  
    def do_get
      get :edit
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the home page relationship" do
      ContentPage.should_receive(:find).once.and_return(@home_page_relationship)
      do_get
    end
  
    it "should assign the home page relationship for the view" do
      do_get
      assigns[:home_page_relationship].should equal(@home_page_relationship)
    end
  end
  
  describe "handling PUT /admin/home_page_relationships" do

     before(:each) do
       @home_page_relationship = HomePageRelationship.new(:directed_relationship_id => 1 )
       HomePageRelationship.stub!(:find).and_return(@home_page_relationship)
     end

     describe "with successful update" do

       def do_put
         #@content_page.should_receive(:update_attributes).and_return(true)
         put :update, :home_page_relationship => { :to_param => people(:janis).to_param, :from_param => people(:jim).to_param }
       end

       it "should find the content_page requested" do
         HomePageRelationship.should_receive(:find).once.and_return(@home_page_relationship)
         do_put
       end

       it "should update the home page relationship" do
         do_put
         assigns(:home_page_relationship).should equal(@home_page_relationship)
       end
       
       it "should find the directed relationship" do
         do_put
         assigns(:directed_relationship).should == directed_relationships(:jim_to_janis)
       end

       it "should update the home page relationship" do
         do_put
         assigns(:home_page_relationship).directed_relationship.should == directed_relationships(:jim_to_janis)
       end

       it "should redirect to the show page" do
         do_put
         response.should render_template('show')
       end

     end

     describe "with non-existent relationship" do

       def do_put
         put :update, :home_page_relationship => { :to_param => people(:janis).to_param, :from_param => people(:elvis).to_param }
       end

       it "should re-render 'edit'" do
         do_put
         response.should redirect_to(edit_admin_home_page_relationships_url)
       end
     end
     
     describe "with invalid person" do

       def do_put
         put :update, :home_page_relationship => { :to_param => 'foobar', :from_param => people(:elvis).to_param }
       end

       it "should re-render 'edit'" do
         do_put
         response.should redirect_to(edit_admin_home_page_relationships_url)
       end
     end    
   end

end

