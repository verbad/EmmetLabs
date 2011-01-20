require File.dirname(__FILE__) + '/../test_helper'

class InternalAssetVersionTest < StorageServicePluginTestCase
  def setup
    super
  end

  def test_url
    version = asset_versions(:basic_1_resized_to_fit)
    flexstub(@storage_service).should_receive(:url_for).once.with(Locator.new(version.id, version.version + '/' + version.filename), {})
    version.url
  end

  def test_destroy
    version = asset_versions(:basic_1_resized_to_fit)
    flexstub(@storage_service).should_receive(:delete).with(version.send(:locator))
    version.destroy
  end

  def test_to_yaml_properties
    assert asset_versions(:basic_1_original).to_yaml_properties.include?(':locator')
  end

  def test_to_yaml
    asset_versions(:basic_1_original).to_yaml
  end

  def test_at_locator
    version = InternalAssetVersion.find(asset_versions(:basic_1_original).id)
    assert_equal version.locator, version.instance_variable_get(':locator')
  end

  def test_data
    version = asset_versions(:basic_1_original)
    flexstub(@storage_service).should_receive(:get).with(version.locator)
  end

end
