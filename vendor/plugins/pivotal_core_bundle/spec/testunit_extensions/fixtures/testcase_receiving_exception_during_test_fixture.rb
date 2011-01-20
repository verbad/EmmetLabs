require 'test/unit'
dir = File.dirname(__FILE__)
require "#{dir}/../../../lib/testunit_extensions/improved_testcase_exception_handler"

class TestCaseReceivingExceptionDuringTestFixture < Test::Unit::TestCase
  def test_exception
    raise Exception
  end
end
