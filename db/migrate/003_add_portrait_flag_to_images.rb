class AddPortraitFlagToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :portrait, :boolean
  end

  def self.down
    drop_column :images, :portrait
  end
end
