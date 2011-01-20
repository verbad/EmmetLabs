dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class BenchmarkTestCaseTest < Test::Unit::TestCase
  include FlexMock::TestCase

  def setup
    @benchmark_test_class = Class.new(Test::Unit::TestCase) do
      include BenchmarkTestCase
      def test_foobar
      end
    end

    @method_to_run = :test_foobar
    @benchmark_test_case = @benchmark_test_class.new(@method_to_run)
  end

  def test_run__should_benchmark_the_run_method
    flexstub(Benchmark).should_receive(:realtime).once.and_return {0.10377272727}
#    flexstub(Benchmark).should_receive(:<<).with("  0.104 sec\ttest_foobar").once
    flexstub(@benchmark_test_case).should_receive(:puts).with("  0.104 sec\t#{@benchmark_test_class.to_s}#test_foobar").once

    result = flexmock("result")
    result.should_receive(:add_run)
    @benchmark_test_case.run(result) {}
  end
end
