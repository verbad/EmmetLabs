require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe PercentageProgressParsingStrategy do
  before do
    @percent_string = "Pos:   5.7s    140f (12%)  41fps Trem:   0min   3mb  A-V:0.015 [591:64] A/Vms 0/20 D/B/S 4/2/1 "
  end

  it "should return integer percent if the string does contain a percentage" do
    percent_int = PercentageProgressParsingStrategy.new.parse(@percent_string)
    percent_int.should == 0.12
  end

  it "should return nil if the string does not contain a percentage" do
    PercentageProgressParsingStrategy.new.parse("asdf").should be_nil
  end
end