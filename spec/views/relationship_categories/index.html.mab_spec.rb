require File.dirname(__FILE__) + '/../../spec_helper'

describe "/admin/relationship_categories/index" do
  include RelationshipCategoriesHelper
  
  before do
    template.assigns[:relationship_categories] = [relationship_categories(:associate), relationship_categories(:child)]
    template.assigns[:relationship_metacategories] = RelationshipMetacategory.find(:all)
  end

  it "should render list of relationship_categories" do
    render "/admin/relationship_categories/index"
    response.body.should include("<h2>Family</h2>")
    response.body.should include("Child")
  end
end
 