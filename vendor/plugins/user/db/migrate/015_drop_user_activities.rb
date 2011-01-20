class DropUserActivities < ActiveRecord::Migration
  def self.up
    drop_table :user_activities
  end

  def self.down
    create_table(:user_activities) do |t|
      t.integer :user_id
      t.string :type
      t.datetime :created_at
    end
  end
end


