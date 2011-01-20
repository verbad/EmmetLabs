require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "The relationship category fixtures" do
  it "should group family relationship categories under the 'Family' metacategory" do
    family_metacategory = relationship_metacategories(:family)
    
    [:parent, :child, :cousin, :relative, :sibling, :partner].each do |category_symbol|
      relationship_category = relationship_categories(category_symbol)
      relationship_category.metacategory.should == family_metacategory
      family_metacategory.categories.should include(relationship_category)
    end
  end

  it "should define opposites for everything that has it" do
    expected_opposite_pairs = {:parent => :child, :child => :parent, :mentor => :student, :student => :mentor}
    expected_opposite_pairs.each do |key, value|
      relationship_categories(key).opposite_id.should == relationship_categories(value).id
    end
  end
end
