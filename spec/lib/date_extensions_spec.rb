require File.dirname(__FILE__) + '/../spec_helper'

describe Date do

  it "should format dates in the Emmet format" do
    Date.parse('2007-11-4').formatted.should == 'Nov 4, 2007'
    Date.parse('2007-11-14').formatted.should == 'Nov 14, 2007'
  end

  it "should know whether it is in the future" do
    Clock.now = Time.parse('2005-01-01 14:00:00').utc
    Date.parse('2002-11-4').should_not be_future
    Date.parse('2010-11-4').should be_future
  end

end
