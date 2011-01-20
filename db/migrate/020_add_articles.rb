class AddArticles < ActiveRecord::Migration
  def self.up
    create_table :relationship_articles do |t|
      t.column :relationship_id, :integer
      t.column :text, :text
      t.column :created_at, :date
      t.column :updated_at, :date
    end
  end

  def self.down
    remove_table :relationship_articles
  end

end
