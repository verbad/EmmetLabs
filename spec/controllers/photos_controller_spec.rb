require File.dirname(__FILE__) + '/../spec_helper'

describe PhotosController do
  it_should_behave_like 'login'

  before do
    @josephine = people(:josephine)
  end

  it "should handle a good image upload" do
    original_count = @josephine.photos.size
    post :create, :type => Person.to_s, :id => @josephine.id, :photoable => {:photo => fixture_path + '/photo.png'}
    response.should be_success
    response.should render_template("photos/create")
    assigns(:photoable).photos.size.should == original_count + 1
    assigns(:photoable).assets_associations.size.should == original_count + 1
    @josephine.reload
    @josephine.photos.size.should == original_count + 1
    assigns(:photo_error_message).should be_nil
  end

  it "should handle a bad image upload" do
    post :create, :type => Person.to_s, :id => @josephine.id, :photoable => {:first_name => '', :last_name=>'', :common_name=>''}
    response.should be_success
    response.should render_template("photos/create")
    assigns(:photo_error_message).should == 'Invalid image!'
  end

  it "should handle listing the photos" do
    get :index, :type => Person.to_s, :id => @josephine.id, :format => 'js'
    assigns(:photoable).should == @josephine
    response.should be_success
    response.should render_template("photos/index")
  end
end

describe PhotosController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end