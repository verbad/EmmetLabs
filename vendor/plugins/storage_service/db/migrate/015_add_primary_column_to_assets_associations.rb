class AddPrimaryColumnToAssetsAssociations < ActiveRecord::Migration
  def self.up
    add_column :assets_associations, :primary, :boolean
  end

  def self.down
    remove_column :assets_associations, :primary
  end

end