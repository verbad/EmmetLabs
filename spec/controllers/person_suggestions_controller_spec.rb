require File.dirname(__FILE__) + '/../spec_helper'

describe PersonSuggestionsController, 'handles index' do
  it_should_behave_like 'login'

  it "should find people with matching name" do
    get :index, :query => 'j', :format => 'js'
    response.should be_success
    assigns(:person_suggestions).should_not be_empty
  end

  it "should resolve the from person and exclude the from person" do
    get :index, :query => 'josephine baker', :from_person_id => people(:josephine).id, :format => 'js'
    response.should be_success
    assigns(:from_person).should == people(:josephine)

    assigns(:person_suggestions).should_not be_include(people(:josephine))
  end

  it "should find exact matching people" do
    get :index, :query => 'josephine baker', :format => 'js'
    response.should be_success
    assigns(:person_suggestions).size.should == 1
  end

  it "should limit to 5 matching people" do
    get :index, :query => 'j', :format => 'js'
    response.should be_success
    assigns(:person_suggestions).size.should == 5
  end

  it "should find no one if no query is entered" do
    get :index, :query => '', :format => 'js'
    response.should be_success
    assigns(:person_suggestions).should be_empty
  end

  it "should find people using common name when given one" do
    get :index, :query => 'prince', :format => 'js'
    response.should be_success

    assigns(:person_suggestions).should be_include(people(:prince_rainier))
  end

  it "should not limit the person search when told not to" do
    get :index, :query => 'j', :show_all => true, :format => 'js'
    response.should be_success

    assigns(:person_suggestions).size.should > 5
    assigns(:show_all).should be_true
  end
end

describe PersonSuggestionsController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end
