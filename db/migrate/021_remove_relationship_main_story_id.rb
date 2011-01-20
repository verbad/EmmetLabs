class RemoveRelationshipMainStoryId < ActiveRecord::Migration
  def self.up
    remove_column :relationships, :main_story_id
  end

  def self.down
    add_column :relationships, :main_story_id, :integer
  end

end
