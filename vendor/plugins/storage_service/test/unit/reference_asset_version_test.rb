require File.dirname(__FILE__) + '/../test_helper'

class ReferenceAssetVersionTest < StorageServicePluginTestCase
  def setup
    super
  end

  def test_url
    reference_version = asset_versions(:reference_to_basic_1_resized_to_fit)
    real_version = asset_versions(:basic_1_resized_to_fit)
    assert_equal real_version.url, reference_version.url
  end
end
