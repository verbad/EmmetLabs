dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require 'active_support'

describe Time, " when the date formatting extension is loaded from Pivotal Core Bundle" do
  
  setup do
    @time = Time.utc(1983, 1, 25)
  end
  
  specify "can be formatted as a dotted date" do
    @time.to_s(:dotted).should == '01.25.83'
  end
  
  specify "can be formatted as a slashed date" do
    @time.to_s(:slashed).should == '01/25/83'
  end
end