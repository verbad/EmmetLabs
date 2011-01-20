require File.dirname(__FILE__) + '/../spec_helper'

describe Node do
  before(:each) do    
    @person_single = people(:prince_albert)
    @person_id = people(:id_collision)
    @person_full = people(:full_collision)

    @entity_single = entities(:lipstick)
    @entity_id = entities(:id_collision)
    @entity_full = entities(:full_collision)
  end
  
  describe ".find_person_or_entity_by_param" do
    it "should return a Person" do
      Node.find_person_or_entity_by_param(@person_single.to_param).should == @person_single
    end

    it "should return an Entity" do
      Node.find_person_or_entity_by_param(@entity_single.to_param).should == @entity_single
    end

    it "should allow for id collisions" do
      #FIXME: eliminate this last "magic string"
      Node.find_person_or_entity_by_param('Entity-with-ID-Collision_10240').should == @entity_id
    end

    it "should return the Person in a complete collision" do
      Node.find_person_or_entity_by_param(@person_full.to_param).should == @person_full
    end
  end
end