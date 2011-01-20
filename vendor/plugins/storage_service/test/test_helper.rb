# These lines must be at the top of each plugin's test_helper
dir = File.dirname(__FILE__)
require "#{dir}/../../pivotal_core_bundle/lib/test_framework_bootstrap"
Test::Unit::TestCase.fixture_path =  File.expand_path(dir + "/fixtures")

RESIZED_TO_FIT_WIDTH = 640
RESIZED_TO_FIT_HEIGHT = 480
SCALED_DOWN_TO_FIT_WIDTH = 640
SCALED_DOWN_TO_FIT_HEIGHT = 480
RESIZED_AND_CROPPED_WIDTH = 90
RESIZED_AND_CROPPED_HEIGHT = 150

class TestPhoto < Photo
  has_versions :resized_to_fit => Asset::Command::Photo::ResizedToFit.new(RESIZED_TO_FIT_WIDTH, RESIZED_TO_FIT_HEIGHT),
    :fake => Asset::Command::FakeResized.new(:resized_to_fit, 10, 10),
    :not_yet_generated => Asset::Command::FakeResized.new(:resized_to_fit, 100, 100)
end

class TestPhotoAssociation < AssetsAssociation
end


class FakeCommand < Asset::Command::Base
  attr_accessor :done
  attr_accessor :fast

  def extension
    'css'
  end

  def initialize
    self.done = false
  end

  def do(source_filename)
    self.done = true
  end

  def fast?
    @fast
  end
end

class SubAsset < Photo
end

class AssociationShim < ActiveRecord::Base
  has_many :assets_associations, :as => :associate, :class_name => "AssetsAssociation"
  has_many :assets, :through => :assets_associations, :as => :associate, :class_name => 'AssetsAssociation'
end

class StorageServicePluginTestCase < Pivotal::FrameworkPluginTestCase
  include FlexMock::TestCase

  fixtures :assets, :asset_versions, :assets_associations

  def setup
    super
    @storage_service = FakeStorageService.new
    silence_warnings {Object.const_set(:STORAGE_SERVICE, @storage_service)}
  end

  def image_as_blob(path)
    img_file = File.open(path)
    img_file.binmode
    raw_img = img_file.read
    img_file.close
    return (raw_img.is_a?(StringIO) ? raw_img : StringIO.new(raw_img))
  end

  def new_asset
    mock_uploaded_data = flexmock("uploaded asset with a :read method")
    mock_uploaded_data.should_receive(:read).and_return {":read method called"}
    mock_uploaded_data.should_receive(:rewind)
    mock_uploaded_data.should_receive(:path)
    mock_uploaded_data.should_receive(:to_tempfile).and_return(mock_uploaded_data)
    Asset.new_by_file(
      :original_filename => "sobo.txt",
      :data => mock_uploaded_data
    )
  end

  def make_mock_asset(filename, id)
    asset = flexmock(filename)
    asset.should_receive(:filename).and_return {filename}
    asset.should_receive(:id).and_return {id}
    asset.should_receive(:locator).and_return {Locator.new(id, filename)}
    return asset
  end

end