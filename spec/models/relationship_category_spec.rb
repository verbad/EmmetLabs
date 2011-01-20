require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipCategory do
  it "should know what its opposite category is" do
    category = relationship_categories(:parent)
    category.opposite_id.should == relationship_categories(:child).id

    category.opposite.should == relationship_categories(:child)
    relationship_categories(:child).opposite.should == category
  end

  it "should have itself as an opposite if no opposite category is specifically defined" do
    category = relationship_categories(:enemy)
    category.opposite_id.should be_nil
    category.opposite.should == category
  end

  it "should be able to find all categories, sorted by name" do
    RelationshipCategory.sorted_by_name.should == RelationshipCategory.find(:all).sort {|category1, category2| category1.name <=> category2.name}
  end

  it "should be able to find parentless categories" do
    expected = RelationshipCategory.find_all_by_metacategory_id(nil)
    RelationshipCategory.parentless.should == expected
  end
  
  it "is only valid if it has a metacategory" do
    category = relationship_categories(:lover)
    category.metacategory_id = nil
    category.should_not be_valid
  end

  it "is only valid it's metacategory exists" do
    category = RelationshipCategory.new(:name => 'foo', :metacategory_id => 99999 )
    category.save
    category.should_not be_valid
  end
end
