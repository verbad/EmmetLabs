require File.dirname(__FILE__) + '/../../spec_helper'

describe "/admin/relationship_categories/new" do
  include RelationshipCategoriesHelper
  
  before do
    @relationship_category = mock_model(RelationshipCategory)
    @relationship_category.stub!(:new_record?).and_return(true)
    @relationship_category.stub!(:name).and_return("MyString")
    @relationship_category.stub!(:metacategory_id).and_return(1)
    template.assigns[:relationship_category] = @relationship_category
    template.assigns[:relationship_metacategories] = RelationshipMetacategory.all
  end

  it "should render new form" do
    render "/admin/relationship_categories/new"
    
    response.should have_tag("form[action=?][method=post]", admin_relationship_categories_path) do
      with_tag("input#relationship_category_name[name=?]", "relationship_category[name]")
    end
  end
end


