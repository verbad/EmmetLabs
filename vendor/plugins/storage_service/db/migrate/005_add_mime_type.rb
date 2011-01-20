class AddMimeType < ActiveRecord::Migration
  def self.up
    add_column :assets, :mime_type, :string
  end

  def self.down
    remove_column :assets, :mime_type
  end
end