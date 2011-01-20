class RenameAssetsVersions < ActiveRecord::Migration
  def self.up
    rename_table :assets_versions, :asset_versions
  end

  def self.down
    rename_table :asset_versions, :assets_versions
  end
end