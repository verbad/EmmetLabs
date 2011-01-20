require File.dirname(__FILE__) + '/../../spec_helper'

describe "/admin/relationship_metacategories/new" do
  include RelationshipMetacategoriesHelper
  
  before do
    @relationship_metacategory = mock_model(RelationshipMetacategory)
    @relationship_metacategory.stub!(:new_record?).and_return(true)
    @relationship_metacategory.stub!(:name).and_return("MyString")
    assigns[:relationship_metacategory] = @relationship_metacategory
  end

  it "should render new form" do
    render "/admin/relationship_metacategories/new"
    
    response.should have_tag("form[action=?][method=post]", admin_relationship_metacategories_path) do
      with_tag("input#relationship_metacategory_name[name=?]", "relationship_metacategory[name]")
    end
  end
end


