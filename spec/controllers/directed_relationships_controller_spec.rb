require File.dirname(__FILE__) + '/../spec_helper'

describe DirectedRelationshipsController, 'handles show' do
  it_should_behave_like 'login'

  before do
    @directed_relationship = directed_relationships(:janis_to_marilyn)
    @directed_relationship2 = directed_relationships(:jim_to_janis)
  end

  it "should assign the directed relationship, and its from and to endpoints" do
    get :show, :from_id => @directed_relationship.from.to_param, :to_id => @directed_relationship.to.to_param
    response.should be_success
    response.should render_template("show")
    assigns(:directed_relationship).should == @directed_relationship
    assigns(:from).should == @directed_relationship.from
    assigns(:to).should == @directed_relationship.to
  end

  it "should respond to XML" do
    get :show, :from_id => @directed_relationship.from.to_param, :to_id => @directed_relationship.to.to_param, :format => "xml"
    response.content_type.should == "application/xml"
    response.should render_template("directed_relationships/show.xml.haml")
  end

  it "should raise ActiveRecord::RecordNotFound for a non-existant to" do
    lambda {
      get :show, :from_id => @directed_relationship.from.to_param, :to_id => "does-not-exist"
    }.should raise_error(ActiveRecord::RecordNotFound)    
  end

  it "should raise ActiveRecord::RecordNotFound for a non-existant from" do
    lambda {
      get :show, :from_id => "does-not-exist", :to_id => @directed_relationship.to.to_param
    }.should raise_error(ActiveRecord::RecordNotFound)    
  end

  it "should raise ActiveRecord::RecordNotFound for a non-existant directed_relationship" do
    lambda {
      get :show, :from_id => people(:no_relationships).to_param, :to_id => @directed_relationship.to.to_param
    }.should raise_error(ActiveRecord::RecordNotFound)    
  end

end

describe DirectedRelationshipsController, 'handles new' do
  it_should_behave_like 'login'

  before do
    @person = people(:josephine)
  end

  it "should handle new given a person id" do
    #TODO: WARNING: This violates REST because it is a GET operation that manipulates data.
    get :new, :person_id => @person.to_param
    response.should be_redirect

    assigns(:categories_count).should_not be_nil
    assigns(:from_node).should == @person
    assigns(:meta_categories).should == RelationshipMetacategory.sorted_by_name
    assigns(:directed_relationship).should be_new_record
  end

  it "should handle being passed a to person id" do
    #TODO: WARNING: This violates REST because it is a GET operation that manipulates data.
    get :new, :person_id => @person.to_param, :to_node_id => people(:abe).to_param, :fomat => 'js'
    response.should be_redirect

    assigns(:categories_count).should_not be_nil
    assigns(:from_node).should == @person
    assigns(:to_node).should == people(:abe)
    assigns(:directed_relationship).should be_new_record
  end

end

describe DirectedRelationshipsController, 'handles update' do
  it_should_behave_like 'login'

  it "should update an existing relationship" do
    directed_relationship = people(:josephine).directed_relationships.first
    old_category_id = directed_relationship.category_id
    old_summary = directed_relationship.relationship.summary
   
    put :update, :id => directed_relationship.to_param, :category_id => relationship_categories(:enemy).id, :relationship => {:summary => 'a new relationship summary'}, :format => 'js'
    response.should be_success
    response.should render_template('create')

    assigns(:directed_relationship).should_not be_nil
    assigns(:directed_relationship).category_id.should_not == old_category_id
    assigns(:directed_relationship).relationship.summary.should_not == old_summary
  end

  it "should update an existing relationship when it is valid to do so" do
    directed_relationship = people(:josephine).directed_relationships.first
    put :update, :id => directed_relationship.to_param, :category_id => relationship_categories(:enemy).id, :relationship => {:summary => ''}, :format => 'js'
    response.should render_template('update')

    assigns(:directed_relationship).relationship.errors.should_not be_empty
  end
end

describe DirectedRelationshipsController, 'handles create' do
  it_should_behave_like 'login'
  self.use_transactional_fixtures = false

  before do
    @person = people(:josephine)
    @unrelated_person = people(:marilyn)
  end

  it "should use an existing person and create a corresponding relationship" do
    prince_albert = people(:prince_albert)
    original_josephine_relationship_count = @person.directed_relationships.size
    original_prince_albert_relationship_count = prince_albert.directed_relationships.size
    post :create, :person_id => @person.to_param, :format => 'js',
         :to_node_id => prince_albert.to_param,
         :category_id => relationship_categories(:friend).id,
         :relationship => {:summary => 'a new relationship summary'}
    response.should render_template("directed_relationships/create")

    @person.reload
    @person.directed_relationships.size.should == original_josephine_relationship_count + 1
    assigns(:directed_relationship).relationship.should_not be_new_record
    assigns(:directed_relationship).relationship.summary.should == 'a new relationship summary'


    prince_albert.reload
    prince_albert.directed_relationships.size.should == original_prince_albert_relationship_count + 1

    directed_relationship = assigns(:directed_relationship)
    directed_relationship.category.should_not be_nil
    directed_relationship.relationship.should_not be_nil
    directed_relationship.relationship.summary.should == 'a new relationship summary'
  end

  it "should roll back the creation of both relationship and directed_relationship when the relationship is valid and the directed_relationship is invalid" do
    original_relationship_count = @person.directed_relationships.size
    post :create, :person_id => @person.to_param, :to_node_id => @unrelated_person.to_param, :format => 'js', :category_id => '', :relationship => {:summary => 'summary'}

    @person.reload
    @person.directed_relationships.size.should == original_relationship_count

    response.should be_success
    response.should render_template("directed_relationships/create")

    assigns(:directed_relationship).errors.should_not be_empty
    assigns(:directed_relationship).should be_new_record
    assigns(:relationship).errors.should be_empty
    new_id = assigns(:relationship).id
    Relationship.find_by_id(new_id).should be_nil
    assigns(:directed_relationship).category.should be_nil
  end
  
  it "should roll back the creation of both the relationship and directed_relationship if the relationship is invalid and the directed_relationship is valid" do
    post :create, :person_id => @person.to_param, :to_node_id => @unrelated_person.to_param, :format => 'js', :category_id => relationship_categories(:lover).id, :relationship => {:summary => ''}
    assigns(:relationship).should be_new_record
    assigns(:directed_relationship).should be_new_record
  end

  it "should roll back the creation of both the relationship and directed_relationship if the relationship is invalid and the directed_relationship is invalid" do
    post :create, :person_id => @person.to_param, :to_node_id => @unrelated_person.to_param, :format => 'js', :category_id => '', :relationship => {:summary => ''}
    assigns(:relationship).should be_new_record
    assigns(:directed_relationship).should be_new_record
  end

  it "should capture author_id in created relationship" do
    post :create, :person_id => @person.to_param, :to_node_id => @unrelated_person.to_param, :format => 'js', :category_id => relationship_categories(:lover).id, :relationship => {:summary => 'summary text'}
    assigns(:directed_relationship).relationship.should_not be_new_record
    assigns(:relationship).should_not be_new_record
    assigns(:relationship).author_id.should == users(:janice).id
  end


end

describe DirectedRelationshipsController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end
