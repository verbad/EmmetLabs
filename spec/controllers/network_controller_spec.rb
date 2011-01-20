require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe NetworkController do
  it_should_behave_like 'login'
  
  before do
    @jim = people(:jim)
    @jim_id = @jim.to_param
  end

  it "should respond to HTML" do
    get :show, :id => @jim.to_param
    assigns(:target_person).should == @jim
    response.should be_success
    response.content_type.should == "text/html"
    response.should render_template("show")
  end

  it "should respond to XML" do
    get :show, :id => @jim.to_param, :format => "xml"
    assigns(:target_person).should == @jim
    response.content_type.should == "application/xml"
    response.should render_template("show")
  end
end

describe NetworkController do
  it "should require login" do
    get :show, :id => people(:jim).to_param
    response.response_code.should == 302
  end
end
