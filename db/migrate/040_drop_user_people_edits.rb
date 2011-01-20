class DropUserPeopleEdits < ActiveRecord::Migration
  def self.up
    drop_table(:user_people_edits)
  end

  def self.down
    create_table(:user_people_edits) do |t|
      t.column :person_id, :integer
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end
end


