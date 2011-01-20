class MilestonesForEntities < ActiveRecord::Migration
  def self.up
    add_column(:milestones, :node_type, :string, :default => 'Person', :null => false)
    rename_column(:milestones, :person_id, :node_id)
  end

  def self.down
    rename_column(:milestones, :node_id, :person_id)
    remove_column(:milestones, :node_type)
  end
end
