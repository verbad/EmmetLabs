require File.dirname(__FILE__) + '/../test_helper'

class StorageServiceBaseTest < StorageServicePluginTestCase
  def setup
    super
    @storage_service = FakeStorageService.new
    @photo_blob = image_as_blob(Test::Unit::TestCase.fixture_path + "/test.gif")
    @test_locator = Locator.new(5, "test.gif")
    @nonexistent_locator = Locator.new(5, "your_mom.gif")
  end

  def test_put_and_get
    @storage_service.put(@test_locator, @photo_blob)
    assert_equal @photo_blob.string, @storage_service.get(@test_locator).string
    assert_equal nil, @storage_service.get(@nonexistent_locator)
  end

  def test_put_and_get__should_normalize_locator
    id = 1
    @storage_service.put(Locator.new(id, "bad file !@# name.rb"), @photo_blob)
    flexstub(@storage_service).should_receive(:find).with(Locator.new(id, 'bad_file_____name.rb')).once
    @storage_service.get(Locator.new(id, "bad file !@# name.rb"))
  end


  def test_delete__should_remove_file
    @storage_service.put(@test_locator, @photo_blob)
    assert @storage_service.exists?(@test_locator)
    @storage_service.delete(@test_locator)
    assert !@storage_service.exists?(@test_locator)
  end

  def test_put__file_upload_with_streaming__expect_success
    string_io_uploaded = StringIO.new('test')
    @storage_service.put(@test_locator, string_io_uploaded)

    big_file_path = File.dirname(__FILE__) + '/../fixtures/sample_big_file.jpg'
    tempfile_uploaded = File.open(big_file_path)
    @storage_service.put(@test_locator, tempfile_uploaded)
  end
end
