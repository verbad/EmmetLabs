require File.dirname(__FILE__) + '/../spec_helper'

describe MilestonesHelper do
  before do
    @milestone = mock('Milestone')
    @milestone.stub!(:year).and_return(2000)
    @milestone.stub!(:month).and_return(1)
    @milestone.stub!(:month?).and_return(true)
    @milestone.stub!(:day).and_return(1)
    @milestone.stub!(:name).and_return('name')
    @prefix = "prefix"
  end
  
  describe "milestone_label" do
    it "should show prefix and all fields with commas between day, year, and name when none are blank" do
      helper.milestone_label(@milestone, @prefix).should == 'prefix Jan 1, 2000, name'
    end
    
    it "should show all fields with commas between day, year, and name when the prefix is blank" do
      helper.milestone_label(@milestone, '').should == 'Jan 1, 2000, name'
    end
    
    it "should show month, then day and year with commas between, when name is blank" do
      @milestone.should_receive(:name).and_return(nil)
      helper.milestone_label(@milestone, @prefix).should == 'prefix Jan 1, 2000'
    end
    
    it "should show month, then year and name with commas between, when day is blank" do
      @milestone.should_receive(:day).and_return(nil)
      helper.milestone_label(@milestone, @prefix).should == 'prefix Jan 2000, name'
    end
    
    it "should show year and name with commas between, when month and day are blank" do
      @milestone.should_receive(:month?).and_return(false)
      @milestone.should_receive(:day).and_return(nil)
      helper.milestone_label(@milestone, @prefix).should == 'prefix 2000, name'
    end
    
    it "should show prefix and year when month, day, and name are blank" do
      @milestone.should_receive(:month?).and_return(false)
      @milestone.should_receive(:day).and_return(nil)
      @milestone.should_receive(:name).and_return(nil)
      helper.milestone_label(@milestone, @prefix).should == 'prefix 2000'
    end
  end
end