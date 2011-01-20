class AddMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.column :person_id, :integer
      t.column :date, :date
      t.column :name, :string
    end
  end

  def self.down
    drop_table :milestones
  end
end
