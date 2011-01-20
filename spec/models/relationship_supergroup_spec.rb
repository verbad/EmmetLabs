require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipSupergroup do

  it "should repond correctly to size" do
    group1 = RelationshipGroup.new(nil, [1, 2, 3, 4, 5])
    group2 = RelationshipGroup.new(nil, [1, 2, 3, 4])
    group3 = RelationshipGroup.new(nil, [1, 2, 3])
    family = relationship_metacategories(:family)
    supergroup = RelationshipSupergroup.new(family, [group1, group2, group3])
    supergroup.name.should == family.name
    supergroup.size.should == 12
  end

end
