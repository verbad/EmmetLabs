class AddAssetCreator < ActiveRecord::Migration
  def self.up
    add_column :assets, :creator_id, :integer
  end

  def self.down
    remove_column :assets, :creator_id
  end
end