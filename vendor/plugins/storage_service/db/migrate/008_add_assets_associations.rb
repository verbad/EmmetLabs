class AddAssetsAssociations < ActiveRecord::Migration
  def self.up
    create_table :assets_associations do |t|
      t.column "asset_id",   :integer
      t.column "type", :string
      t.column "associate_id",   :integer
      t.column "associate_type", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "position", :integer
    end
  end

  def self.down
    drop_table :assets_associations
  end
end