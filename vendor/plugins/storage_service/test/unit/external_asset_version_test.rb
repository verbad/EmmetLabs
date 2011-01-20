require File.dirname(__FILE__) + '/../test_helper'

class ExternalAssetVersionTest < StorageServicePluginTestCase
  def setup
    super
    @external_version = asset_versions(:external)
  end

  def test_url
    assert_equal @external_version.uri, @external_version.url
  end

  def test_completed
    assert @external_version.completed?
  end

  def test_pending
    assert !@external_version.pending?
  end

  def test_data
    assert_not_nil @external_version.data
  end
end
