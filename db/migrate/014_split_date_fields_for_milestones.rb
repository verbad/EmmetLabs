class SplitDateFieldsForMilestones < ActiveRecord::Migration
  def self.up
    add_column :milestones, :year, :integer
    add_column :milestones, :month, :integer
    add_column :milestones, :day, :integer

    milestones = Milestone.find(:all)
    milestones.each do |milestone|
      unless milestone.date.nil?
        milestone.year = milestone.date.year
        milestone.month = milestone.date.month
        milestone.month = milestone.date.day
      end
      milestone.save!
    end

    remove_column :milestones, :date
  end

  def self.down
    raise IrreversibleMigration
  end
end
