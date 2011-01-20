require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TimeProgressParsingStrategy do
  before do
    @line_for_time = "Pos:   10.0s     50f ( 0%)  21fps Trem:   0min   0mb  A-V:0.043 [875:52] A/Vms 1/42 D/B/S 3/3/1"
  end

  it "should return true if the string contains a time" do
    percentage = TimeProgressParsingStrategy.new(100).parse @line_for_time
    percentage.should == 0.1
  end

  it "should return nil if the string does not contain a time" do
    time = TimeProgressParsingStrategy.new(100).parse "asdfasdfasdfasdf"
    time.should be_nil
  end
end