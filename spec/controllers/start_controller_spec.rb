require File.dirname(__FILE__) + '/../spec_helper'

describe StartController, "handling GET" do
  it_should_behave_like 'login'

  before do
    @person = mock('Person')
    @id = 1
    @name = 'Janice Joplin'
    
    @relationship = mock('Relationship')
    @directed = mock('DirectedRelationship')
    @bidirectional = [@directed, @directed]
    @homepage = mock('HomePageRelationship')
    
    Person.stub!(:new).and_return(@person)
    Person.stub!(:most_active_recently).and_return(@person)
    Person.stub!(:sorted_by_relationship_count_and_full_name).and_return([@person, @person])
    @person.stub!(:id).and_return(@id)
    @person.stub!(:name).and_return(@name)

    DirectedRelationship.stub!(:new).and_return(@directed)
    DirectedRelationship.stub!(:find).and_return([@directed])

    HomePageRelationship.stub!(:find).and_return(@homepage)
    @homepage.stub!(:directed_relationship).and_return(@directed)

    UserAction.stub!(:find).and_return([@person, @person])

    get :show
    response.should be_success
  end

  it "should set random relationships" do
    DirectedRelationship.should_receive(:find).and_return([@directed])

    rand = assigns[:random_relationships]
    rand.should_not be_empty
  end
  
  it "should have a featured relationship" do
    HomePageRelationship.should_receive(:find).and_return(@homepage)
    @homepage.should_receive(:directed_relationship).and_return(@directed)
    
    assigns[:featured].should == @directed
  end
  
  it "should have a most active person" do
    Person.should_receive(:most_active_recently).and_return(@person)
    
    assigns[:most_active_person].should == @person
  end

  it "should have a person with the strongest network" do
    Person.should_receive(:sorted_by_relationship_count_and_full_name)
    assigns[:strongest_network].should == @person
  end
  
  it "should have a set of recently updated relationships" do
    UserAction.should_receive(:find)
    
    assigns[:recently].should be_is_a(Array)
    assigns[:recently][0].should == @person
  end
end

describe StartController do
  it "should require login" do
    get :show
    response.response_code.should == 302
  end
end