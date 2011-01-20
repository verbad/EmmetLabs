require File.dirname(__FILE__) + '/../test_helper'

class FakeComposableCommand < Asset::Command::Base
  def self.data
    @@data
  end

  def extension
    nil
  end

  def do(data)
    @@data = (@@data ||= '') + data.read
    data.rewind; data
  end
end

class CommandTest < StorageServicePluginTestCase
  def setup
    super
  end

  def test_compose
    text = "blah"
    first_tmpfile = StringIO.new(text).to_tempfile

    command = FakeComposableCommand * FakeComposableCommand * FakeComposableCommand
    command.new.do(first_tmpfile)
    assert_equal text * 3, FakeComposableCommand.data
  end

  def test_to_yaml
    command = Asset::Command::Base.new
    command.version = asset_versions(:basic_1_resized_to_fit)
    assert command.to_yaml_properties.include?("@version")
    assert_equal "--- !ruby/object:Asset::Command::Base \nversion: &id001 !ruby/object:InternalAssetVersion \n  locator: !ruby/struct:Locator \n    id: 1\n    path: resized_to_fit/1.png\n  id: 1\n  original: !ruby/object:InternalAssetVersion \n    locator: !ruby/struct:Locator \n      id: 1\n      path: original/1.png\n    id: 3\nversion: *id001\n",
      command.to_yaml
  end
  
  def test_by_default_commands_are_fast
    command = Asset::Command::Base.new
    assert command.fast?
  end
  
  def test_start_and_finish
    command = FakeCommand.new
    mock_data = flexmock("data")
    mock_data.should_receive(:read)
    mock_data.should_receive(:rewind)
    flexstub(STORAGE_SERVICE).should_receive(:get).and_return(mock_data)
    command.start(assets(:basic_1), :resized_to_fit)
    version = command.version
    assert version.pending?
    command.finish
    assert command.done
    assert version.completed?
  end
  
end