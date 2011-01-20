class InitialCommentsPluginSchema < ActiveRecord::Migration
  def self.up
    create_table "comments", :force => true do |t|
      t.string :type, :null => false
      t.integer :author_id, :null => false
      t.string :author_type, :null => false
      t.integer :target_id, :null => false
      t.string :target_type, :null => false
      t.text :text
      t.integer :rating
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
    end

    if ['test', 'development'].include? RAILS_ENV
      create_table "commentable_shims", :force => true do |t|
        t.string :value
      end
    end
  end

  def self.down
    drop_table :comments
    drop_table :commentable_shims if ['test', 'development'].include? RAILS_ENV
  end
end
