class AddIndexToAssetAssociation < ActiveRecord::Migration
  def self.up
    add_index :assets_associations, :primary
  end

  def self.down
    remove_index :assets_associations, :primary
  end
end
