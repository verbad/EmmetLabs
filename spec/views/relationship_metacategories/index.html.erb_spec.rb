require File.dirname(__FILE__) + '/../../spec_helper'

describe "/admin/relationship_metacategories/index" do
  include RelationshipMetacategoriesHelper
  
  before do
    relationship_metacategory_98 = mock_model(RelationshipMetacategory)
    relationship_metacategory_98.should_receive(:name).and_return("MyString")
    relationship_metacategory_99 = mock_model(RelationshipMetacategory)
    relationship_metacategory_99.should_receive(:name).and_return("MyString")

    assigns[:relationship_metacategories] = [relationship_metacategory_98, relationship_metacategory_99]
  end

  it "should render list of relationship_metacategories" do
    render "/admin/relationship_metacategories/index"
    response.should have_tag("tr>td", "MyString", 2)
  end
end

