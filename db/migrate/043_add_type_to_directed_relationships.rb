class AddTypeToDirectedRelationships < ActiveRecord::Migration
  def self.up
    add_column :directed_relationships, :from_type, :string
    add_column :directed_relationships, :to_type, :string
    
    DirectedRelationship.update_all "`from_type` = 'Person', `to_type` = 'Person'"
  end

  def self.down
    remove_column :directed_relationships, :from_type
    remove_column :directed_relationships, :to_type
  end
end
