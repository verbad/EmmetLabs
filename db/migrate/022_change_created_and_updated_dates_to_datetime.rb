class ChangeCreatedAndUpdatedDatesToDatetime < ActiveRecord::Migration

  TABLES = %w{directed_relationships milestones people relationship_articles relationship_categories relationship_metacategories relationships }

  def self.up
    TABLES.each do |table_name|
      change_column table_name, :created_at, :datetime
      change_column table_name, :created_at, :datetime
    end
  end

  def self.down
    TABLES.each do |table_name|
      change_column table_name, :created_at, :date
      change_column table_name, :created_at, :date
    end
  end

end
