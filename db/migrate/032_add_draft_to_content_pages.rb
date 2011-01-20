class AddDraftToContentPages < ActiveRecord::Migration
  def self.up
    add_column :content_pages, :draft, :boolean
  end

  def self.down
    remove_column :content_pages, :draft
  end
end
