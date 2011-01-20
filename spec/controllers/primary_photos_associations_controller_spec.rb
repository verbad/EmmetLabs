require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe PrimaryPhotosAssociationsController do
  it_should_behave_like 'login'
  
  before do
    @person = people(:janis)
    @photo1 = assets(:photo_1)
    @photo2 = assets(:photo_2)
    @association1 = assets_associations(:photo_association_1)
    @association2 = assets_associations(:photo_association_2)
  end
  
  it "should allow changing which association is primary" do
    @person.primary_photo.should == @photo1

    post :update, :id => @association2.id
    response.response_code.should == 302

    @person.assets_associations.reload
    @person.primary_photo.should == @photo2
  end

  it "should allow changing which association is primary through ajax" do
    @person.primary_photo.should == @photo1

    post :update, :id => @association2.id, :format => 'js'
    response.response_code.should == 200
    assigns(:photoable).should == @person
    response.should render_template('update')

    @person.assets_associations.reload
    @person.primary_photo.should == @photo2
  end

end

describe PrimaryPhotosAssociationsController do
  it "should require login" do
    post :update, :id => 0
    response.response_code.should == 302
  end
end
