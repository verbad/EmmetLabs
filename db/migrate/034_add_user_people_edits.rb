class AddUserPeopleEdits < ActiveRecord::Migration
  
  def self.up
    create_table(:user_people_edits) do |t|
      t.column :person_id, :integer
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end
  
  def self.down
    remove_table :user_people_edits
  end
  
  
end