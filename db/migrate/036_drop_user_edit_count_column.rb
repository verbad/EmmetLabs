class DropUserEditCountColumn < ActiveRecord::Migration
  def self.up    
    remove_column :user_people_edits, :count
  end

  def self.down
    add_column :user_people_edits, :count, :integer , :default => 0
  end
end