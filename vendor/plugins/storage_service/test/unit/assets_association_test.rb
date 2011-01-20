require File.dirname(__FILE__) + '/../test_helper'

class AssetsAssociationTest < StorageServicePluginTestCase

  def test_positioning
    asset = assets(:sub_asset)
    shim = AssociationShim.new
    association_the_first = AssetsAssociation.create!(
        :asset => asset,
        :associate => shim)

    association_the_second = AssetsAssociation.create!(
        :asset => asset,
        :associate => shim)

    association_the_third = AssetsAssociation.create!(
        :asset => asset,
        :associate => shim)

    assert_equal 1, association_the_first.position
    assert_equal 2, association_the_second.position
    assert_equal 3, association_the_third.position

    association_the_third.move_to_top
    association_the_third.reload
    association_the_second.reload
    association_the_first.reload

    assert_equal 2, association_the_first.position
    assert_equal 3, association_the_second.position
    assert_equal 1, association_the_third.position
  end

  def test_make_primary_if_only_assets_association
    shim = AssociationShim.new
    association_the_first = AssetsAssociation.create!(
      :asset => assets(:basic_1),
      :associate => shim)

    assert_true association_the_first.primary?

    association_the_second = AssetsAssociation.create!(
      :asset => assets(:basic_2),
      :associate => shim)

    assert_false association_the_second.primary?
    assert_true association_the_first.primary?
  end

  def test_deletion_of_only_primary
    shim = AssociationShim.new
    association_the_first = AssetsAssociation.create!(
      :asset => assets(:basic_1),
      :associate => shim)

    association_the_first.destroy
  end

  def test_update_primary_upon_deletion_of_primary
    shim = AssociationShim.new
    association_the_first = AssetsAssociation.create!(
      :asset => assets(:basic_1),
      :associate => shim)
    association_the_second = AssetsAssociation.create!(
      :asset => assets(:basic_2),
      :associate => shim)

    association_the_first.destroy
    association_the_second.reload

    assert_true association_the_second.primary?
  end
end
