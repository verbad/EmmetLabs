require File.dirname(__FILE__) + '/../test_helper'

class FlashCommandTest < StorageServicePluginTestCase
  def setup
    super
  end

  def test_office
    command = Asset::Command::Conversion::OfficeToFlash.new(100,200)
    flexstub(Asset::Command).should_receive(:exec)
    file = flexmock("file")
    flexstub(File).should_receive(:open).and_return(file)
    flexstub(File).should_receive(:unlink)
    file.should_receive(:write)
    file.should_receive(:rewind)
    file.should_receive(:path).and_return('jizzunk')
    command.do(StringIO.new("asdfasdf").to_tempfile)
  end
end