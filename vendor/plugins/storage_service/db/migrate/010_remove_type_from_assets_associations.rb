class RemoveTypeFromAssetsAssociations < ActiveRecord::Migration
  def self.up
    remove_column 'assets_associations', 'type'
  end

  def self.down
    add_column 'assets_associations', 'type', :string
  end
end