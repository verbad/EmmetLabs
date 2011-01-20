require File.dirname(__FILE__) + '/../test_helper'

class FakeResizedCommandTest < StorageServicePluginTestCase
  def setup
    super
    @command = Asset::Command::FakeResized.new(:real_version, 100, 200)
  end

  def test_basics
    assert_equal @command.size, AssetVersion::Size.new(100, 200)
    assert_equal 200, @command.height
    assert_equal :real_version, @command.real_version_name
    assert_equal ReferenceAssetVersion, @command.version_class
  end

  def test_do
    data = StringIO.new 'blah'
    assert_equal data, @command.do(data)
  end
end