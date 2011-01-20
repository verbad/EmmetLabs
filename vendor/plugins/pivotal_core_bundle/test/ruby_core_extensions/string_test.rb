dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class StringExtensionTest < Pivotal::IsolatedPluginTestCase

  def test_to_id_name
    test_string = "Table Id"
    assert_equal "table_id", test_string.to_id_name
  end

  def test_unquote_with_single_quote
    test_string = "'single quoted'"
    assert_equal "single quoted", test_string.unquote
  end

  def test_unquote_with_double_quote
    test_string = "'double quoted'"
    assert_equal "double quoted", test_string.unquote
  end
end