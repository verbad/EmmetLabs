dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "An At Exit callback that has an exception inside of it" do
  specify "should exit with a code 1" do
    dir = File.dirname(__FILE__)
    fixture_path = "#{dir}/fixtures/at_exit_callback_fixture.rb"

    cmd = "ruby #{fixture_path}"
    system(cmd).should be_false unless RUBY_VERSION == "1.8.6"
  end
end
