class AddContentPages < ActiveRecord::Migration
  def self.up
    create_table :content_pages do |t|
      t.column :name, :string
      t.column :calculated_dashified_name, :string
      t.column :text, :text
    end
  end

  def self.down
    drop_table :content_pages
  end
end
