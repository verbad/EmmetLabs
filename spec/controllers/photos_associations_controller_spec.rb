require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe PhotosAssociationsController do
  it_should_behave_like 'login'
  
  before do
    @person = people(:janis)
    @association = assets_associations(:photo_association_1)
  end

  it "should allow deleting of association" do
    @person.assets_associations.should be_include(@association)
    size = @person.photos.size
    delete :destroy, :id => @association.id
    response.response_code.should == 302
    @person.assets_associations.reload
    @person.assets_associations.should_not be_include(@association)
  end

  it "should allow deleting of association through ajax" do
    @person.assets_associations.should be_include(@association)
    size = @person.photos.size
    delete :destroy, :id => @association.id, :format => 'js'
    response.response_code.should == 200
    assigns(:photoable).should == @person
    response.should render_template('destroy')
    @person.assets_associations.reload
    @person.assets_associations.should_not be_include(@association)
  end

end

describe PhotosAssociationsController do
  it "should require login" do
    delete :destroy, :id => 0
    response.response_code.should == 302
  end
end
