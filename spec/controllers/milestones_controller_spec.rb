require File.dirname(__FILE__) + '/../spec_helper'

describe MilestonesController do
  it_should_behave_like 'login'

  before do
    @person = people(:josephine)
  end

  it "should respond to show xml" do
    get :index, :node_id => @person.to_param, :format => 'xml'
    response.should be_success
    response.content_type.should == "application/xml"
  end

  it "should respond to new" do
    get :new, :person_id => @person.to_param, :distinguisher => 'xyz', :format => 'js'
    response.should be_success
    assigns(:distinguisher).should == 'xyz'
    response.content_type.should == "text/javascript"
  end

  it "should respond to update" do
    post :create,
        :person_id => @person.to_param,
        :milestone_id_1 => {:name => 'Made dinner for husband', :year=>1950, :month=>4, :day=>2, :year_multiplier => '1'},
        :milestone_id_2 => {:name => 'Shot uncle', :year => 1960, :month => 4, :day => 2, :estimate => 'true', :year_multiplier => '1'},
        :milestone_id_8 => {:name => 'qwerty', :year => '1906', :year_multiplier => '1'},
        :format => 'js'
    response.should be_success
    response.should render_template('_index')
    @person.birth_milestone.name.should == 'qwerty'

    milestone1 = Milestone.find(1)
    milestone1.name.should == 'Made dinner for husband'
    milestone1.year.should == 1950
    milestone1.month.should == 4
    milestone1.day.should == 2
    milestone1.estimate?.should be_false

    milestone2 = Milestone.find(2)
    milestone2.name.should == 'Shot uncle'
    milestone2.year.should == 1960
    milestone2.month.should == 4
    milestone2.day.should == 2
    milestone2.estimate?.should be_true
  end

  it "should create a new milestone" do
    original_count = @person.milestones.length
    post :create,
        :person_id => @person.to_param,
        :milestone_new_1 => {:name => 'a new milestone', :year =>1960, :month=>2, :day=>1, :year_multiplier=>'1'},
        :milestone_new_2 => {:name => 'another new milestone', :year =>1980, :month=>3, :year_multiplier=>'1'}
    response.should be_success
    response.should render_template('_index')
    assigns(:node).milestones.length.should == original_count + 2
    
    @person.reload
    @person.milestones.length.should == original_count + 2

    first_new = @person.milestones.select {|milestone| milestone.name == 'a new milestone'}.first
    first_new.year.should == 1960
    first_new.month.should == 2
    first_new.day.should == 1

    second_new = @person.milestones.select {|milestone| milestone.name == 'another new milestone'}.first
    second_new.year.should == 1980
    second_new.month.should == 3
    second_new.day.should be_nil

    assigns(:errors).should be_nil
  end

  it "should handle fuzzy dates on milestones" do
    original_count = @person.milestones.length
    post :create, :person_id => @person.to_param, :milestone_id_1 => {:name => 'Made dinner for husband', :year=>'1950', :month=>'', :day=>'', :year_multiplier=>'1'}
    response.should be_success
    milestone1 = Milestone.find(1)
    milestone1.year.should == 1950
    milestone1.month.should be_nil
    milestone1.day.should be_nil
    assigns(:errors).should be_nil
  end

  it "should handle validation errors" do
    post :create, :person_id => @person.to_param, :milestone_id_1 => {:name => 'Made dinner for husband', :year=>'1908', :month=>'', :day=>'12', :year_multiplier=>'1'}
    response.should be_success
    milestone1 = Milestone.find(1)
    milestone1.name.should == 'Got married in Thailand'
    milestone1.year.should == 1907
    milestone1.month.should == 10
    milestone1.day.should == 5

    assigns(:errors).should be_true
  end

  it "should handle validation errors on new milestones" do
    original_count = @person.milestones.length
    post :create, :person_id => @person.to_param, :milestone_new_1 => {:day => '12', :name => 'New milestone', :year_multiplier => '1'}
    response.should be_success
    assigns(:errors).should be_true
    assigns(:node).milestones.size.should == original_count + 1
    @person.reload
    @person.milestones.size.should == original_count
  end

  it "should consider a blank year invalid" do
    original_count = @person.milestones.length
    post :create, :person_id => @person.to_param, :milestone_new_1 => {:name => 'new milestone', :year=>'Year', :year_multiplier => '1'}
    response.should be_success

    @person.reload
    @person.milestones.size.should == original_count
  end

  it "should handle a BCE year" do
    post :create, :person_id => @person.to_param, :milestone_id_1 => {:name => 'new milestone', :year=>'1000', :year_multiplier => '-1'}
    response.should be_success
    assigns(:errors).should be_nil

    @person.reload
    Milestone.find(1).year.should == -1000
  end

  it "should delete an existing milestone" do
    married = milestones(:josephine_married)

    delete :destroy, :person_id => @person.to_param, :id => married.id
    response.should be_success

    Milestone.find_by_id(married.id).should be_nil
  end

  it "should ignore blank milestones" do
    original_count = Milestone.count
    post :create, :person_id => @person.to_param, :milestone_new_id_1 => {:year => 'Year'}
    response.should be_success
    assigns(:errors).should be_nil

    @person.reload
    Milestone.count.should == original_count
  end
end

describe MilestonesController do
  it "should require login" do
    get :index, :person_id => people(:josephine).to_param
    response.response_code.should == 302
  end
end