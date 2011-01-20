require File.dirname(__FILE__) + '/../test_helper'

class ExternalReferenceCommandTest < StorageServicePluginTestCase
  def setup
    super
    @command = Asset::Command::ExternalReference.new(100, 200)
  end

  def test_basics
    assert_equal @command.size, AssetVersion::Size.new(100, 200)
    assert_equal ExternalAssetVersion, @command.version_class
  end

  def test_do
    data = StringIO.new 'blah'
    assert_equal data, @command.do(data)
  end
end