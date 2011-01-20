class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table(:people) do |t|
      t.column :name, :string
    end

    create_table(:relationships) do |t|
      t.column :main_story_id, :integer
    end

    create_table(:directed_relationships) do |t|
      t.column :from_id, :integer
      t.column :to_id, :integer
      t.column :relationship_id, :integer
      t.column :category_id, :integer
    end

    create_table(:relationship_categories) do |t|
      t.column :name, :string
      t.column :metacategory_id, :integer
      t.column :opposite_id, :integer
    end
    
    create_table(:relationship_metacategories) do |t|
      t.column :name, :string
    end

    create_table(:relationship_stories) do |t|
      t.column :relationship_id, :integer
      t.column :text, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :verisimilitude, :integer
    end
    
    create_table(:people_tags, :id => false) do |t|
      t.column :person_id, :integer
      t.column :tag_id, :integer
    end
    
    create_table(:tags) do |t|
      t.column :name, :string
    end

    create_table(:images) do |t|
      t.column :person_id, :integer
      t.column :flickr_id, :integer
    end

    create_table(:images_people, :id => false) do |t|
      t.column :person_id, :integer
      t.column :image_id, :integer
    end
  end

  def self.down
    drop_table :directed_relationships
    drop_table :relationships
    drop_table :people
    drop_table :relationship_categories
    drop_table :relationship_metacategories
    drop_table :relationship_stories
    drop_table :people_tags
    drop_table :tags
    drop_table :images
    drop_table :images_people
 end
end