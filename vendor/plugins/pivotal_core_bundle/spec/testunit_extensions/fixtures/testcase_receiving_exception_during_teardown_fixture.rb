require 'test/unit'
dir = File.dirname(__FILE__)
require "#{dir}/../../../lib/testunit_extensions/improved_testcase_exception_handler"

class TestCaseReceivingExceptionDuringTeardownFixture < Test::Unit::TestCase
  def teardown
    raise Exception
  end

  def test_foobar
  end
end
