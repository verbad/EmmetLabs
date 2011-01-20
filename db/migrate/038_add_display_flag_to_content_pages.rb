class AddDisplayFlagToContentPages < ActiveRecord::Migration
  def self.up
    add_column :content_pages, :display_in_footer, :boolean, :default => true
  end

  def self.down
    remove_column :content_pages, :display_in_footer
  end
end
