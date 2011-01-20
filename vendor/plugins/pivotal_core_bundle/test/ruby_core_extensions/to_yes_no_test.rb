dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class ToYesNoTest < Pivotal::IsolatedPluginTestCase
  def test_booleans
    assert_equal "Yes", true.to_yes_no
    assert_equal "No", false.to_yes_no
    assert_equal "No", nil.to_yes_no
  end
end