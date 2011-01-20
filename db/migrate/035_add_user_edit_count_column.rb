class AddUserEditCountColumn < ActiveRecord::Migration
  def self.up    
    add_column :user_people_edits, :count, :integer , :default => 0
  end

  def self.down
    remove_column :user_people_edits, :count
  end
end
