class AddTitlesToStories < ActiveRecord::Migration
  def self.up
    add_column :relationship_stories, :title, :string
    execute "UPDATE relationship_stories SET title = 'Untitled' WHERE title IS NULL"
  end

  def self.down
    drop_column :relationship_stories, :title
  end
end
