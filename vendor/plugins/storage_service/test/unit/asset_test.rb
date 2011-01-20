require File.dirname(__FILE__) + '/../test_helper'

class AssetTest < StorageServicePluginTestCase
  def setup
    super
    @filename = "file.txt"
    @mock_data = flexmock("uploaded data with a :read method")
    @mock_data.should_receive(:read).and_return("123")
    @mock_data.should_receive(:rewind).and_return(1)
    @flickr_photo_url = "http://farm1.static.flickr.com/153/412862615_07cf3cb573.jpg"
  end
  
  def test_validates_format
    photo = TestPhoto.new_by_file(:original_filename => @filename)
    assert !photo.valid?
    photo.errors[:format]
  end

  def test_brackets
    assert_equal asset_versions(:basic_1_resized_to_fit), assets(:basic_1).versions[:resized_to_fit]
  end

  def test_has_version
    asset = assets(:basic_1)
    assert asset.has_version?(:resized_to_fit)
    assert !asset.has_version?(:not_yet_generated)

    flexstub(@storage_service).should_receive(:get).and_return(@mock_data)
    new_version = asset.versions[:not_yet_generated]
    assert asset.has_version?(:not_yet_generated)
  end

  def test_lazy_version_generation
    flexstub(@storage_service).should_receive(:get).and_return(@mock_data)
    new_version = assets(:basic_1).versions[:not_yet_generated]
    assert_not_nil new_version.reload
  end

  def test_version_does_not_generate_when_no_data
    flexstub(@storage_service).should_receive(:get).and_return(nil)
    assert_raise(Asset::OriginalDataIsMissingError) {new_version = assets(:basic_1).versions[:not_yet_generated]}
  end

  def test_save__when_invalid__should_not_store_asset
    asset = Asset.new_by_file(:original_filename => @filename)
    flexstub(asset).should_receive(:valid?).and_return {false}
    flexstub(@storage_service).should_receive(:put).never
    asset.save
  end
  
  def test_save__does_not_save_when_data_is_empty
    asset = Asset.new_by_file(:data => '')
    assert !asset.valid?
    assert_raises(ActiveRecord::RecordInvalid) do
      asset.save!
    end
  end

  def test_save__stores_asset_when_resetting_data
    asset = new_asset
    flexstub(@storage_service).should_receive(:put).once
    asset.save

    new_data = flexmock("new data with a :read method")
    new_data.should_receive(:read).and_return {"new data :read_method"}
    new_data.should_receive(:rewind)
    new_data.should_receive(:to_tempfile).and_return(new_data)
    new_data.should_receive(:path)
    asset.data = new_data

    flexstub(@storage_service).should_receive(:put).once
    asset.save
  end

  def test_save__does_not_store_asset_when_not_resetting_data
    asset = new_asset
    asset.save!
    flexstub(@storage_service).should_receive(:put).never
    asset.save!
  end

  def test_create__creates_versions
    flexstub(UnknownAsset).should_receive(:versions).and_return({:version_name => FakeCommand.new})
    asset = new_asset
    asset.save
    assert_not_nil asset.versions[:original]
    assert_not_nil asset.versions[:version_name]
  end

  def test_destroy__destroys_versions
    asset = new_asset
    asset.save
    version = flexmock("version")
    version.should_receive(:destroy)
    flexstub(asset).should_receive(:versions).and_return([version])
    asset.destroy
  end

  def test_new_by_file__creates_correct_type
    asset = Asset.new_by_file(:original_filename => 'asdf.mov')
    assert_equal Video, asset.class
    asset = Asset.new_by_file(:original_filename => 'asdf.mp3')
    assert_equal Audio, asset.class
    asset = Asset.new_by_file(:original_filename => 'asdf.gif')
    asset = Asset.new_by_file(:original_filename => 'asdf.doc')
    assert_equal Document, asset.class
    asset = Asset.new_by_file(:original_filename => 'asdf.xls')
    assert_equal Spreadsheet, asset.class
    asset = Asset.new_by_file(:original_filename => 'asdf.pdf')
    assert_equal Pdf, asset.class
    asset = Asset.new_by_file(:original_filename => 'asdf.ppt')
    assert_equal Presentation, asset.class
    asset = Asset.new_by_file(:original_filename => 'asdf.jpg')
    assert_equal Photo, asset.class
    asset = Asset.new_by_file(:original_filename => 'asdf')
    assert_equal UnknownAsset, asset.class
  end

  def test_new_from_upload__creates_correct_type
    asset = Photo.new_from_upload(:original_filename => 'asdf.mov')
    assert_equal Photo, asset.class
  end

  def test_create_remote_asset_from_url
    flickr_photo = get_remote_asset(@flickr_photo_url)
    assert flickr_photo.save!
  end

  def test_create_remote_asset__should_store_source
    flickr_photo = get_remote_asset(@flickr_photo_url)
    assert_equal @flickr_photo_url, flickr_photo.source_uri
  end

  def test_external?
    local_asset = assets(:sub_asset)
    assert !local_asset.external?

    remote_asset = get_remote_asset(@flickr_photo_url)
    assert remote_asset.external?
  end

  def test_remote_asset_has_original_filename
    remote_asset = Photo.new
    remote_asset.data = @flickr_photo_url
    assert_equal "412862615_07cf3cb573.jpg", remote_asset.original_filename
    assert remote_asset.valid?
  end

  def test_assets_associations
    assert_equal [assets_associations(:basic_association_1)], assets(:basic_1).assets_associations
  end

  def test_assets_can_access_their_associates
    associate, asset, association = destroy_all_associations_and_make_just_one
    assert_equal [associate], asset.associates
  end

  def test_assets_associations_are_destroyed_with_asset
    asset = assets(:basic_1)
    asset.destroy
    assert asset.assets_associations.reload.empty?
  end
  
  private

  def get_remote_asset(source_uri)
    remote_asset = Photo.new
    remote_asset.data = source_uri
    remote_asset.original_filename = "file_name.jpg"
    remote_asset
  end

  def make_an_association(asset, associate)
    the_association_between = AssetsAssociation.create!(
        :asset => asset,
        :associate => associate)

    return the_association_between
  end

  def destroy_all_associations_and_make_just_one
    AssetsAssociation.destroy_all
    shim = AssociationShim.create!(:name => "Shimmy")
    asset = assets(:sub_asset)
    association = make_an_association(asset, shim)
    shim.reload
    asset.reload
    association.reload
    return shim, asset, association
  end
end
