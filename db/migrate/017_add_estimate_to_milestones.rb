class AddEstimateToMilestones < ActiveRecord::Migration
  def self.up
    add_column :milestones, :estimate, :boolean
  end

  def self.down
    remove_column :milestones, :estimate
  end
end
