require File.dirname(__FILE__) + '/../spec_helper'

describe DirectedRelationship do

  it "should destroy associated directed relationships when it itself is destroyed" do
    directed_rel = directed_relationships(:josephine_to_grace)

    relationship = directed_rel.relationship
    opposite_directed_rel = directed_relationships(:grace_to_josephine)

    directed_rel.destroy
    DirectedRelationship.find_by_id(directed_rel.id).should be_nil
    Relationship.find_by_id(relationship.id).should be_nil
    DirectedRelationship.find_by_id(opposite_directed_rel.id).should be_nil
  end

  it "creates appropriate directed relationships upon instantiation" do

    josephine = people(:josephine)
    jim = people(:jim)
    category = relationship_categories(:child)

    jim.should_not be_related_to(josephine)
    josephine.should_not be_related_to(jim)

    directed_rel = DirectedRelationship.new(:from => jim, :to => josephine, :category => category, :relationship => Relationship.create!(:summary => 'text', :author_id => 10))

    directed_rel.from.should == jim
    directed_rel.to.should == josephine
    directed_rel.category.should == category

    directed_rel.save!

    relationship = directed_rel.relationship
    relationship.should_not be_nil

    jim.reload
    josephine.reload
    jim.directed_relationships.to(josephine).category.should == category
    jim.directed_relationships.to(josephine).relationship.should == relationship

    josephine.directed_relationships.to(jim).category.should == category.opposite
    josephine.directed_relationships.to(jim).relationship.should == relationship

    relationship.directed_relationships.size.should == 2
  end

  it "lets you get at the story list directly rather than through the relationship object" do
    directed_rel = directed_relationships(:jfk_to_marilyn)
    assert_equal [relationship_stories(:jfk_and_marilyn_0), relationship_stories(:jfk_and_marilyn_1)], directed_rel.relationship.stories
    assert_equal [relationship_stories(:jfk_and_marilyn_0), relationship_stories(:jfk_and_marilyn_1)], directed_rel.stories
  end
  
  it "is only valid if it has a relationship_category_id" do
    directed_rel = directed_relationships(:josephine_to_grace)
    directed_rel.category_id = nil
    directed_rel.should_not be_valid
  end
  
  it "is only valid if it has a to_id" do
    directed_rel = directed_relationships(:josephine_to_grace)
    directed_rel.to_id = nil
    directed_rel.should_not be_valid
  end
  
  it "is only valid if it has a from_id" do
    directed_rel = directed_relationships(:josephine_to_grace)
    directed_rel.from_id = nil
    directed_rel.should_not be_valid
  end

  it "does not allow the same person on both ends of the relationship" do
    josephine = people(:josephine)
    relationship = DirectedRelationship.new(:from => josephine, :to => josephine, :category_id => relationship_categories(:friend).id)
    relationship.should_not be_valid
  end
  
  it "does not allow a duplicate relationship" do
    existing_relationship = DirectedRelationship.find(:all).first
    relationship = DirectedRelationship.new(:from => existing_relationship.from, :to => existing_relationship.to, :category_id => relationship_categories(:friend).id)
    relationship.should_not be_valid
  end

  it "should return its opposite directed_relationship" do
    directed_relationship = directed_relationships(:josephine_to_grace)
    directed_relationship.opposite.should == directed_relationships(:grace_to_josephine)
  end

end
