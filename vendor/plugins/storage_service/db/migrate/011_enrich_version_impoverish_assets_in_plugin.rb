class EnrichVersionImpoverishAssetsInPlugin < ActiveRecord::Migration
  def self.up
    remove_column :assets, :asset_owner_type
    remove_column :assets, :asset_owner_id
    remove_column :assets, :path
    remove_column :assets, :mime_type
    add_column :assets_versions, :filename, :string rescue nil
    add_column :assets_versions, :mime_type, :string
  end

  def self.down
    add_column :assets, :asset_owner_type, :string
    add_column :assets, :asset_owner_id, :integer
    add_column :assets, :path, :string
    add_column :assets, :mime_type, :string
    remove_column :assets_versions, :filename
    remove_column :assets_versions, :mime_type
  end
end