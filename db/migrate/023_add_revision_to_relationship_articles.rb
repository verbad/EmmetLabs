class AddRevisionToRelationshipArticles < ActiveRecord::Migration
  def self.up
    add_column :relationship_articles, :revision, :integer
  end

  def self.down
    remove_column :relationship_articles, :revision
  end

end
