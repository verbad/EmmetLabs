class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    #create_table :tags do |t|
    #  t.column :name, :string
    #end
    
    # people_tags doesn't have an id column. Rather than turn it into taggings, create new.
    create_table :taggings do |t|
      t.column :tag_id, :integer
      t.column :taggable_id, :integer
      # You should make sure that the column created is
      # long enough to store the required class names.
      t.column :taggable_type, :string

      t.column :tagger_id, :integer
      t.column :tagger_type, :string
      
      t.column :context, :string
      
      t.column :created_at, :datetime
    end
    
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]
    
    execute <<-EndSQL
      INSERT INTO taggings (tag_id, taggable_id, taggable_type, context, created_at)
      SELECT  tag_id, person_id, 'Person', 'tags', now()
      FROM    people_tags
    EndSQL
    
    drop_table :people_tags
  end
  
  def self.down
    create_table :people_tags do |t|
      t.column :tag_id, :integer
      t.column :person_id, :integer
    end
    
    # for consistency
    remove_column :people_tags, :id
    
    execute <<-EndSQL
      INSERT INTO people_tags (tag_id, person_id)
      SELECT  tag_id, taggable_id
      FROM    taggings
    EndSQL
    
    drop_table :taggings
    # drop_table :tags
  end
end
