class AddCreatedAtAndUpdatedAt < ActiveRecord::Migration
  def self.up
    add_to(:directed_relationships)
    add_to(:milestones)
    add_to(:people)
    add_to(:relationship_categories)
    add_to(:relationship_metacategories)
    add_to(:relationships)
  end

  def self.down
    remove_from(:directed_relationships)
    remove_from(:milestones)
    remove_from(:people)
    remove_from(:relationship_categories)
    remove_from(:relationship_metacategories)
    remove_from(:relationships)
  end

  private

  def self.add_to(table)
    add_column table, :created_at, :date
    add_column table, :updated_at, :date
  end

  def self.remove_from(table)
    remove_column table, :created_at
    remove_column table, :updated_at
  end
end
