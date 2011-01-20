require File.dirname(__FILE__) + '/../test_helper'

class AssetVersionTest < StorageServicePluginTestCase
  def setup
    super
  end

  def test_original
    assert_equal asset_versions(:basic_1_original), asset_versions(:basic_1_resized_to_fit).original
  end
end
