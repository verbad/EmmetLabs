require File.dirname(__FILE__) + '/../test_helper'

class HasAssetShim < ActiveRecord::Base
  set_table_name :association_shims
  has_assets
end

class HasAssetShimWithDifferentClass < ActiveRecord::Base
  set_table_name :association_shims
  has_assets :photos, :class_name => 'TestPhoto'
end

class HasAssetShimWithDifferentAssociation < ActiveRecord::Base
  set_table_name :association_shims
  has_assets :through => :test_photo_associations
end

class HasAssetShimWithDifferentClassAndDifferentAssociation < ActiveRecord::Base
  set_table_name :association_shims
  has_assets :photos, :class_name => 'TestPhoto', :through => :test_photo_associations
end

class HasAssetTest < StorageServicePluginTestCase
  def setup
    super
    @has_asset = HasAssetShim.create
  end

  def test_has_many_assets_associations
    assert_equal [], @has_asset.assets_associations
  end

  def test_has_many_assets
    assert_equal [], @has_asset.assets
  end

  def test_assets_build__specified_class
    has_asset = HasAssetShimWithDifferentClassAndDifferentAssociation.create
    has_asset.assets.build(:data => fixture_file_upload('/test.gif', 'image/gif')).save
    assert_equal 1, has_asset.assets_associations.size
    assert_equal 1, has_asset.assets.size
  end

  def test_assets_build__unspecified_class
    has_asset = HasAssetShim.create
    has_asset.assets.build(:data => fixture_file_upload('/test.gif', 'image/gif')).save
    assert_equal Photo, has_asset.assets.first.class
  end

  def test_positioning_uses_position_on_association
    associate = HasAssetShim.create!(:name => 'your dad')
    assert_empty associate.assets_associations
    associate.assets_associations.create(:asset => assets(:basic_3))
    associate.assets_associations.create(:asset => assets(:basic_1))
    associate.assets_associations.create(:asset => assets(:basic_2))
    assert_equal [assets(:basic_3), assets(:basic_1), assets(:basic_2)], associate.reload.assets
  end

  def test_primary_photo__with_no_assets__should_return_default
     associate_without_photos = HasAssetShim.create!(:name => 'your mom')
     assert_equal DefaultPhoto, associate_without_photos.primary_asset.class
  end

  def test_primary_asset__with_one_asset__should_return_that_asset
    associate = HasAssetShim.create!(:name => 'your dad')
    associate.assets_associations.create(:asset => assets(:basic_1))
    assert_equal assets(:basic_1), associate.primary_asset
  end

  def test_primary_asset_equals__asset_not_already_associated__associates_it_and_makes_it_primary
    associate = HasAssetShim.create!(:name => 'your dad')
    associate.primary_asset = assets(:basic_2)
    associate.save
    assert_equal [assets(:basic_2)], associate.assets
    assert_equal assets(:basic_2), associate.reload.primary_asset
  end

  def test_primary_asset_equals__already_associated_with_asset
    associate = HasAssetShim.create!(:name => 'your dad')
    associate.assets_associations.create(:asset => assets(:basic_1))
    associate.assets_associations.create(:asset => assets(:basic_2))
    assert_equal assets(:basic_1), associate.primary_asset
    associate.primary_asset = assets(:basic_2)
    associate.save
    assert_equal assets(:basic_2), associate.reload.primary_asset
  end

  def test_primary_asset_equals__already_associated_with_asset__tentatively_set
    associate = HasAssetShim.create!(:name => 'your dad')
    associate.assets_associations.create(:asset => assets(:basic_1))
    associate.assets_associations.create(:asset => assets(:basic_2))
    assert_equal assets(:basic_1), associate.primary_asset
    associate.primary_asset = assets(:basic_2)
    assert_equal assets(:basic_2), associate.primary_asset
  end

  def test_asset_equals
    associate = HasAssetShim.new(:asset => fixture_file_upload('/test.gif', 'image/gif'))
    associate.save!
    assert !associate.reload.assets.empty?
  end

  def test_asset_equals__bunk_upload
    associate = HasAssetShim.new(:asset => '')
    associate.save!
    assert associate.reload.assets.empty?
  end

  def test_has_asset__with_association_subtype
    associate = HasAssetShimWithDifferentAssociation.new
    associate.assets_associations.build(:asset => assets(:basic_1))
    associate.save!
    assert_equal(TestPhotoAssociation, associate.assets_associations[0].class)
  end

  def test_has_asset__with_class__should_have_assets_that_are_only_that_class
    assert_equal SubAsset, assets(:sub_asset).class
    associate = HasAssetShimWithDifferentClass.create!
    associate.assets_associations.create!(:asset => assets(:sub_asset))
    assert_empty associate.reload.assets
  end

  def test_has_asset__with_name__should_have_method_named_primary_photo_and_photo_equals_etc
    associate = HasAssetShimWithDifferentClass.create!
    associate.assets_associations.create(:asset => assets(:basic_1))
    assert_equal assets(:basic_1), associate.reload.primary_photo
    associate.photo = fixture_file_upload('/test.gif', 'image/gif')
    associate.save
    assert_equal 2, associate.reload.photos.size    
  end
end
