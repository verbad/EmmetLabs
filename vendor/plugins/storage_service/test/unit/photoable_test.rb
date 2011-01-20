require File.dirname(__FILE__) + '/../test_helper'

class PhotoableShim < AssociationShim
  include Photoable.new(TestPhoto)
end


class SinglePhotoableShim < AssociationShim
  include Photoable.new(TestPhoto, {:cardinality => :single_photo})
end

class PhotoableShimWithDifferentAssociation < AssociationShim
  include Photoable.new(TestPhoto, {:association_class => TestPhotoAssociation})
end

class PhotoableTest < StorageServicePluginTestCase
  def test_primary_photo
     AssetsAssociation.destroy_all
         association_without_photos = PhotoableShim.create!(:name => 'your mom')
         assert_equal DefaultPhoto, association_without_photos.primary_photo.class

    association_with_photos = PhotoableShim.create!(:name => 'your dad')
    association_with_photos.photos << assets(:basic_1)
    assert_equal assets(:basic_1), association_with_photos.primary_photo
  end

  def test_chevron
    association = PhotoableShim.create!(:name => 'your dad')
    assert_empty association.assets_associations
    association.photos << assets(:basic_1)
    assert association.reload.assets_associations.size > 0
  end

  def test_photo_positioning_uses_position_on_association
    association = PhotoableShim.create!(:name => 'your dad')
    assert_empty association.assets_associations
    association.photos << assets(:basic_3)
    association.photos << assets(:basic_1)
    association.photos << assets(:basic_2)
    assert_equal [assets(:basic_3), assets(:basic_1), assets(:basic_2)], association.reload.photos
  end

  def test_single_photo_set_replaces_photo_collection_with_the_photo_that_was_set
    association = SinglePhotoableShim.create!(:name => 'your dad')
    association.primary_photo = assets(:basic_3)
    association.save!
    assert_equal [assets(:basic_3)], association.reload.photos

    association.primary_photo = assets(:basic_2)
    association.save!
    assert_equal [assets(:basic_2)], association.reload.photos
  end

  def test_transforms_a_multipart_form_upload_object_into_a_photo
    fred = User.new

    upload = fixture_file_upload('/test.gif', 'image/gif')
    association = SinglePhotoableShim.create!(:name => 'your dad')

    association.primary_photo_from_upload(upload, fred)

    assert_equal TestPhoto, association.primary_photo.class
    assert_equal fred, association.primary_photo.creator
  end
  
  def test_validates_associated_photos
    fred = User.new

    upload = fixture_file_upload('/test.txt', 'text/txt')
    association = SinglePhotoableShim.create!(:name => 'your dad')

    association.primary_photo_from_upload(upload, fred)
    assert !association.primary_photo.valid?

    assert !association.valid?    
  end


  def test_multiple_photo__primary_photo_set__moves_photo_to_top
    photoable = PhotoableShim.create!(:name => 'your dad')
    photoable.primary_photo = assets(:basic_1)
    photoable.save!
    photoable.primary_photo = assets(:basic_2)
    photoable.save!
    photoable.primary_photo = assets(:basic_3)
    photoable.save!
    assert_equal ids([assets(:basic_3), assets(:basic_2), assets(:basic_1)]), ids(photoable.reload.photos)
    photoable.primary_photo = assets(:basic_2)
    photoable.save!
    assert_equal ids([assets(:basic_2), assets(:basic_3), assets(:basic_1)]), ids(photoable.reload.photos)
  end


  def test_different_association_subtype
    photoable = PhotoableShimWithDifferentAssociation.new
    photoable.save!
    
    photoable.primary_photo = assets(:basic_1)
    photoable.save!

    assert_equal(TestPhotoAssociation, photoable.reload.assets_associations[0].class)
  end

  def ids(collection)
    collection.collect { |item| item.id }
  end

end
