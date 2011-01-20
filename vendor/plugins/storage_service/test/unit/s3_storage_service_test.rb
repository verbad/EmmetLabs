require File.dirname(__FILE__) + '/../test_helper'

class S3StorageServiceTest < StorageServicePluginTestCase

  def setup
    super
    @repository = "any_kind_of_random_bucket_name"
    @access_key = S3StorageService.read_access_key(Test::Unit::TestCase.fixture_path + "/keys/dev.s3_access.key")
    @secret_key = S3StorageService.read_access_key(Test::Unit::TestCase.fixture_path + "/keys/dev.s3_secret.key")
    @storage_service = S3StorageService.new(@repository,@access_key,@secret_key)
    @locator = Locator.new(3, "test.gif")
    @nonexistent_locator = Locator.new(4, "does_not_exist.txt")
    @photo_blob = image_as_blob(Test::Unit::TestCase.fixture_path + "/test.gif")
  end

  def test_put
    @storage_service.put(@locator, @photo_blob)
    assert_equal @photo_blob.string,
      @storage_service.get(@locator).string
  end

  def test_get__with_non_existent_filename
    assert_equal nil, @storage_service.get(@nonexistent_locator)
  end

  def test_exists
    @storage_service.put(@locator, @photo_blob)
    assert @storage_service.exists?(@locator)
    assert !@storage_service.exists?(@nonexistent_locator)
  end

  def test_url_for__should_create_url_to_s3_url_and_bucket_and_file_path
    full_s3_url = "http://s3.amazonaws.com/#{@repository}/3/test.gif"
    assert_equal full_s3_url, @storage_service.url_for(@locator)
  end

  def test_delete__should_remove_file
    @storage_service.put(@locator, @photo_blob)
    assert @storage_service.exists?(@locator)
    @storage_service.delete(@locator)
    assert ! @storage_service.exists?(@locator)
  end

  def test_store__should_connect_before_store__when_disconnected
    flexstub(AWS::S3::Base).should_receive(:connected?).once.and_return(false)
    keys = {
      :access_key_id     => @access_key,
      :secret_access_key => @secret_key,
      :persistent        => false
    }
    flexstub(AWS::S3::Base).should_receive(:establish_connection!).once.
      with(keys)
    flexstub(AWS::S3::S3Object).should_receive(:store)

    @storage_service.put(@locator, @photo_blob)
  end

  def test_store__should_disconnect_after_store
    flexstub(AWS::S3::Base).should_receive(:connected?).once.and_return(true)
    flexstub(AWS::S3::S3Object).should_receive(:store).once.with("3/test.gif", @photo_blob, @repository, {:access => :public_read})
    flexstub(AWS::S3::Base).should_receive(:disconnect!).once

    assert AWS::S3::Base.respond_to?(:disconnect!)

    @storage_service.put(@locator, @photo_blob)
  end

  def test_store__should_disconnect_after_store__when_there_is_an_error
    flexstub(AWS::S3::Base).should_receive(:connected?).once.and_return(true)
    flexstub(AWS::S3::S3Object).should_receive(:store).and_return{raise RuntimeError}
    flexstub(AWS::S3::Base).should_receive(:disconnect!).once
    assert AWS::S3::Base.respond_to?(:disconnect!)

    assert_raises(RuntimeError) do
      @storage_service.put(@locator, @photo_blob)
    end
  end

  def test_put__file_upload_with_streaming__expect_success
    string_io_uploaded = StringIO.new('test')
    @storage_service.put(@locator, string_io_uploaded)

    big_file_path = File.dirname(__FILE__) + '/../fixtures/sample_big_file.jpg'
    tempfile_uploaded = open(big_file_path)
    @storage_service.put(@locator, StringIO.new(big_file_path))
  end

  def test_time_limited_link
    3.times do
      p "THIS TEST HAS BEEN DISABLED test_time_limited_link s3_storage_service_test"
    end
#    @storage_service.put(@locator, @photo_blob)
#    assert_equal @photo_blob.string, @storage_service.get(@locator).string
#
#    time_limited_url = @storage_service.url_for(@locator, :expires_in => 61)
#    assert time_limited_url.include?("&Expires="), "There should be an expires parameter in the URL"
#    begin
#      assert_equal @photo_blob.string, open(time_limited_url).read
#    rescue OpenURI::HTTPError => e
#      fail("The time limited URL shouldn't be forbidden immediately") if e.to_s.include?("403")
#      raise e
#    end
#    #Waiting 62 seconds.  sorry.  amazon's time-limited link appears to require a minimum 60 seconds.
#    sleep 62
#
#    begin
#      open(time_limited_url).read
#    rescue OpenURI::HTTPError => e
#      assert e.to_s.include?("403"), e.to_s
#    end
  end
end