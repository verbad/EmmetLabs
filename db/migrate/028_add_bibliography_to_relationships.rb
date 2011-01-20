class AddBibliographyToRelationships < ActiveRecord::Migration
  def self.up
    add_column :relationships, :bibliography, :text
  end

  def self.down
    remove_column :relationships, :bibliography
  end
end
