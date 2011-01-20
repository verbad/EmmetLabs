class AddUriToVersionAndOriginalFilenameToAssetInPlugin < ActiveRecord::Migration
  def self.up
    add_column :asset_versions, :uri, :string
    add_column :asset_versions, :type, :string
    add_column :assets, :original_filename, :string
  end

  def self.down
    remove_column :asset_versions, :type
    remove_column :asset_versions, :uri
    remove_column :assets, :original_filename
  end
end