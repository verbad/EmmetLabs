require File.dirname(__FILE__) + '/../test_helper'

class LocalDiskStorageServiceTest < StorageServicePluginTestCase

  def setup
    super
    @repository = "testrepository"
    @asset_root_path = RAILS_ROOT + '/public/assets'
    @storage_service = LocalDiskStorageService.new(@asset_root_path, "/assets")
    @photo_blob = image_as_blob(Test::Unit::TestCase.fixture_path + "/test.gif")
    @asset = make_mock_asset("test.gif", 3)
    @locator = @asset.locator
    @nonexistent_asset = make_mock_asset("doesnotexist.gif", 4)
    @nonexistent_locator = @nonexistent_asset.locator
  end

  def teardown
    repo_dir = @asset_root_path + "/" + @repository
    if File.exists?(repo_dir)
      FileUtils.rm_r(@asset_root_path)
    end
    super
  end

  def test_put_and_get
    @storage_service.put(@locator, @photo_blob)
    assert_equal @photo_blob.string, @storage_service.get(@locator).string
  end
  
  def test_get__with_non_existent_filename
    assert_equal nil, @storage_service.get(@nonexistent_locator)
  end

  def test_get__when_file_open_fails_for_another_reason
    @storage_service.put(@locator, StringIO.new("iamcorrupt"))
    assert @storage_service.exists?(@locator), "We want one that works"
    flexstub(File).should_receive(:open).and_return {nil}
    assert_equal nil, @storage_service.get(@locator)
  end

  def test_exists
    @storage_service.put(@locator, @photo_blob)
    assert @storage_service.exists?(@locator)
    assert !@storage_service.exists?(@nonexistent_locator)
  end

  def test_delete__should_remove_file
    @storage_service.put(@locator, @photo_blob)
    assert @storage_service.exists?(@locator)
    @storage_service.delete(@locator)
    assert ! @storage_service.exists?(@locator)
  end

  def test_url_for
    assert_equal "/assets", @storage_service.url_prefix
    assert_equal 3, @asset.id
    assert_equal "test.gif", @asset.filename
    assert_equal "/assets/3/test.gif", @storage_service.url_for(@locator)
  end

end