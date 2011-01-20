class AddPolymorphicInterfaceToAssets < ActiveRecord::Migration
  def self.up
    add_column 'assets', 'asset_owner_type', :string
    add_column 'assets', 'asset_owner_id', :integer
  end

  def self.down
    remove_column 'assets', 'asset_owner_type'
    remove_column 'assets', 'asset_owner_id'
  end
end