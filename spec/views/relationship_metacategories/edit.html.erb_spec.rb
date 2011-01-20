require File.dirname(__FILE__) + '/../../spec_helper'

describe "/admin/relationship_metacategories/edit" do
  include RelationshipMetacategoriesHelper
  
  before do
    @relationship_metacategory = mock_model(RelationshipMetacategory)
    @relationship_metacategory.stub!(:name).and_return("MyString")
    assigns[:relationship_metacategory] = @relationship_metacategory
  end

  it "should render edit form" do
    render "/admin/relationship_metacategories/edit"
    
    response.should have_tag("form[action=#{admin_relationship_metacategory_path(@relationship_metacategory)}][method=post]") do
      with_tag('input#relationship_metacategory_name[name=?]', "relationship_metacategory[name]")
    end
  end
end


