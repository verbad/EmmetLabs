require File.dirname(__FILE__) + '/../spec_helper'

describe DirectedRelationshipCategoriesController do
  it_should_behave_like 'login'

  it "should respond to update and change a directed relationship's category and update its opposite's category" do
    directed_relationship = directed_relationships(:grace_to_josephine)
    expected_directed_relationship_category =  relationship_categories(:child)
    expected_directed_relationship_category_id =  expected_directed_relationship_category.id
    old_directed_relationship_category_id = directed_relationship.category.id

    directed_relationship.category.should_not == expected_directed_relationship_category

    put :update, :directed_relationship_id => directed_relationship.to_param, :id => directed_relationship.to_param, :directed_relationship => {:category_id =>expected_directed_relationship_category_id },
          :format => 'js'

    response.should be_success
    response.should render_template('update')

    updated_directed_relationship = assigns(:directed_relationship)
    updated_directed_relationship.opposite.reload

    updated_directed_relationship.category.should == expected_directed_relationship_category
    updated_directed_relationship.opposite.category.should == expected_directed_relationship_category.opposite
  end

  it "should respond to update and handle no category id" do
    directed_relationship = directed_relationships(:grace_to_josephine)
    expected_directed_relationship_category =  directed_relationship.category

    put :update, :directed_relationship_id => directed_relationship.to_param, :id => directed_relationship.to_param,
          :format => 'js'
    response.should be_success
    response.should render_template('update')
 
    assigns(:directed_relationship).category.should == expected_directed_relationship_category
  end
end

describe DirectedRelationshipCategoriesController do
  it "should require login" do
    put :update, :directed_relationship_id => directed_relationships(:grace_to_josephine).to_param, :id =>directed_relationships(:grace_to_josephine).to_param
    response.response_code.should == 302
  end
end