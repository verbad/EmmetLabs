require File.dirname(__FILE__) + '/../test_helper'

class LocatorTest < StorageServicePluginTestCase
  def setup
    super
  end

  def test_normalize
    assert_equal '/asdf/asdf/asdf______.gif', Locator.new(1, '/asdf/asdf/asdf@#$@#$.gif').normalize.path
  end
end
