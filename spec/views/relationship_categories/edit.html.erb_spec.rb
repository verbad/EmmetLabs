require File.dirname(__FILE__) + '/../../spec_helper'

describe "/admin/relationship_categories/edit" do
  include RelationshipCategoriesHelper
  
  before do
    @relationship_category = relationship_categories(:lover)
    template.assigns[:relationship_category] = @relationship_category
    template.assigns[:relationship_metacategories] = RelationshipMetacategory.all
    template.assigns[:relationship_categories] = RelationshipCategory.all
  end

  it "should render edit form" do
    render "/admin/relationship_categories/edit"
    
    response.should have_tag("form[action=#{admin_relationship_category_path(@relationship_category)}][method=post]") do
      with_tag('input#relationship_category_name[name=?]', "relationship_category[name]")
    end
  end
end


