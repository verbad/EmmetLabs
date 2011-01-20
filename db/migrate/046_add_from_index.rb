class AddFromIndex < ActiveRecord::Migration
  def self.up
    add_index(:directed_relationships, :from_id)
  end
  
  def self.down
    remove_index(:directed_relationships, :from_id)
  end
  
end
