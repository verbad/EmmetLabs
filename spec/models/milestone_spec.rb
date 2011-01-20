require File.dirname(__FILE__) + '/../spec_helper'

describe Milestone do

  it "needs a year" do
    milestone = Milestone.new
    milestone.should_not be_valid
    milestone.errors.size.should == 1

    milestone.year = 2000
    milestone.should be_valid
  end

  it "needs a month if has a day" do
    milestone = Milestone.new
    milestone.should_not be_valid
    milestone.errors.size.should == 1

    milestone.year = 2000
    milestone.day = 5
    milestone.should_not be_valid

    milestone.year = 2000
    milestone.month = 4
    milestone.should be_valid
  end

  it "is invalid if it is a birth type and one already exists for the person" do
    birthdateless = people(:jfk)
    birthdateless.birth_milestone.should be_nil
    birthdateless.should be_valid

    has_birthdate = people(:josephine)
    has_birthdate.birth_milestone.should_not be_nil
    has_birthdate.should be_valid

    milestone = create_birth_milestone_for(birthdateless)
    milestone.should be_valid

    milestone = create_birth_milestone_for(has_birthdate)
    milestone.should_not be_valid
  end

  it "validates that the date is in the past" do
    valid_milestone = milestones(:josephine_married)
    valid_milestone.year = 3010
    valid_milestone.should_not be_valid
  end

  it "disallows non-integer years" do
    milestone = milestones(:josephine_married)
    milestone.should be_valid

    milestone.update_attributes({:year => "Year"})
    milestone.should_not be_valid

    milestone.update_attributes({:year => "5"})
    milestone.should be_valid

    milestone.update_attributes({:year => "-5"})
    milestone.should be_valid
  end

  it "supports changing year multiplier" do
    milestone = milestones(:josephine_married)
    milestone.year.should == 1907
    milestone.year_multiplier=-1
    milestone.save!
    milestone.year.should == -1907
  end

  it "knows if it is blank" do
    milestones(:josephine_married).should_not be_blank
    Milestone.new(:year => 2000).should_not be_blank
    Milestone.new.should be_blank
  end

  private

  def create_birth_milestone_for(node)
    Milestone.create(:node_id => node.id, :node_type => node.class.name, :type_id => Milestone::Type[:birth].id, :year => 2000, :name=>'Baltimore')
  end

end
