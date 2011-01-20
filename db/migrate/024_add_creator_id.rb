class AddCreatorId < ActiveRecord::Migration
  TABLES = %w{directed_relationships milestones people relationship_articles relationship_categories relationship_metacategories relationship_stories relationships }

  def self.up
    TABLES.each do |table_name|
      add_column  table_name, :creator_id, :integer
      add_index   table_name, :creator_id
    end
  end

  def self.down
    TABLES.each do |table_name|
      remove_index  table_name, :creator_id
      remove_column table_name, :creator_id
    end
  end
end
