require "rubygems"
require "#{File.dirname(__FILE__)}/../lib/test_framework_bootstrap"
require "suites/suite_runner"

class TestSuite < Suites::SuiteRunner
  def run
    dir = File.dirname(__FILE__)
    run_cmd "ruby #{dir}/../spec/spec_suite.rb", "Spec"
    run_cmd "ruby #{dir}/test_unit_suite.rb", "Spec"

    raise "Suite Failed" unless success?
  end
end

if $0 == __FILE__
  TestSuite.new.run
end
