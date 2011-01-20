require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipGroup do

  it "should repond correctly to size" do
    lover = relationship_categories(:lover)
    group = RelationshipGroup.new(lover, [1, 2, 3, 4, 5])
    group.name.should == lover.name
    group.size.should == 5
  end

end
