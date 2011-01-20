dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A TestCase receiving a Interrupt Exception during test" do
  specify "should record the exception as an error" do
    dir = File.dirname(__FILE__)
    fixture_path = "#{dir}/fixtures/testcase_receiving_exception_during_test_fixture.rb"

    cmd = "ruby #{fixture_path}"
    output = `#{cmd}`
    $?.exitstatus.should == 1 unless RUBY_VERSION == "1.8.6"
    output.should include("1 errors")
  end
end

describe "A TestCase receiving a Interrupt Exception during teardown" do
  specify "should record the exception as an error" do
    dir = File.dirname(__FILE__)
    fixture_path = "#{dir}/fixtures/testcase_receiving_exception_during_teardown_fixture.rb"

    cmd = "ruby #{fixture_path}"
    output = `#{cmd}`
    $?.exitstatus.should == 1 unless RUBY_VERSION == "1.8.6"
    output.should include("1 errors")
  end
end
