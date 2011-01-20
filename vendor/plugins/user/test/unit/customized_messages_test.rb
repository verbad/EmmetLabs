require File.dirname(__FILE__) + '/../test_helper'

class CustomizedMessagesTest < Test::Unit::TestCase
  def test_string_customize_method_returns_same_string_by_default
    assert_equal("foo","foo".customize)
  end

  def test_customize_can_translate_a_string
    String.add_customized_message("standard1", "customized")
    assert_equal("customized","standard1".customize)    
  end

  def test_customize_loads_overrides_from_config_file
    assert_equal("customized from config","standard2".customize)
  end

  def test_customize_can_do_substitutions
    String.add_customized_message("standard {:first} standard {:next}",
      "custom {:first} custom {:next}")
    assert_equal("custom foo custom bar",
      "standard {:first} standard {:next}".customize(:first => 'foo', :next => 'bar'))
    assert_equal("custom 4 custom 8",
        "standard {:first} standard {:next}".customize(:first => 4, :next => 8))
  end

  def test_customize_can_do_multiple_substitutions
    assert_equal("standard foo foo standard bar bar",
          "standard {:first} {:first} standard {:next} {:next}".customize(:first => 'foo', :next => 'bar'))
  end
end

