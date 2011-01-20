require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipMetacategory do
  before(:each) do
    @relationship_metacategory = RelationshipMetacategory.new
  end

  it "should be valid" do
    @relationship_metacategory.should be_valid
  end
end
