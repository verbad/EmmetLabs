class RenameRelationshipCreatorToAuthor < ActiveRecord::Migration
  def self.up
    AddCreatorId::TABLES.each do |table|
      rename_column table, :creator_id, :author_id
    end
  end

  def self.down
    AddCreatorId::TABLES.each do |table|
      rename_column table, :author_id, :creator_id
    end
  end
end