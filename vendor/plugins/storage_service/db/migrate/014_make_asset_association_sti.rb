class MakeAssetAssociationSti < ActiveRecord::Migration
  def self.up
    add_column :assets_associations, :type, :string
  end

end