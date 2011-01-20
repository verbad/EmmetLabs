require File.dirname(__FILE__) + '/../test_helper'

class RemoteWorkerTest < StorageServicePluginTestCase
  def setup
    super
    @worker = Asset::Worker::Remote.new(InMemoryQueue.new)
  end

  def test_do__slow_command
    command = FakeCommand.new
    assert !command.done
    flexstub(@worker.queue).should_receive(:push).with(command).once
    asset = new_asset
    asset.save
    @worker.do(command, asset, :version_name)
    assert !command.done
    assert_equal AssetVersion::State[:pending], command.version.state
    assert_equal 'text/css', command.version.mime_type
    assert_equal 'sobo.txt.css', command.version.filename
  end
  
  def test_do__fast_command
    command = FakeCommand.new
    command.fast = true
    assert !command.done
    flexstub(@worker.queue).should_receive(:push).with(command).never
    asset = new_asset
    asset.save
    @worker.do(command, asset, :version_name)
    assert command.done
    assert_equal AssetVersion::State[:completed], command.version.state
    assert_equal 'text/css', command.version.mime_type
    assert_equal 'sobo.txt.css', command.version.filename
  end
end
