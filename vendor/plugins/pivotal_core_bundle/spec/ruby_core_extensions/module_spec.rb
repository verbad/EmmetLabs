dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe Module, "#redefine_const" do
  specify "redefines the constant when it is already set" do
    mod = Module.new
    mod.const_set(:FOOBAR, 1)
    $stderr.should_not_receive(:write)
    mod.redefine_const(:FOOBAR, 2)
    mod.const_get(:FOOBAR).should == 2
  end

  specify "sets the constant when it is not set" do
    mod = Module.new
    $stderr.should_not_receive(:write)
    mod.redefine_const(:FOOBAR, 2)
    mod.const_get(:FOOBAR).should == 2
  end
end
