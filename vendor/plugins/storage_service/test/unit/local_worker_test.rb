require File.dirname(__FILE__) + '/../test_helper'

class LocalWorkerTest < StorageServicePluginTestCase
  def setup
    super
  end

  def test_do
    command = FakeCommand.new
    assert !command.done
    ASSET_WORKER.do(command, new_asset, :version_name)
    assert command.done
    assert_equal AssetVersion::State[:completed], command.version.state
    assert_equal 'text/css', command.version.mime_type
    assert_equal 'sobo.txt.css', command.version.filename
  end
end
