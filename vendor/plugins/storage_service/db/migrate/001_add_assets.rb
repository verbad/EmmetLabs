class AddAssets < ActiveRecord::Migration

  def self.up
    create_table :assets do |t|
      t.column :path, :string
      t.column :type, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

  end

  def self.down
    drop_table :assets
  end
end