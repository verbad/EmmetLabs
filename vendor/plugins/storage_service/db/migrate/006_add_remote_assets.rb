class AddRemoteAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :source_uri, :string
  end

  def self.down
    remove_column :assets, :source_uri
  end
end