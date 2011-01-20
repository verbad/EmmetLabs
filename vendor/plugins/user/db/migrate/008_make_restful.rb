class MakeRestful < ActiveRecord::Migration
  def self.up
    add_column :profiles, :first_name, :string
    add_column :profiles, :last_name, :string
    add_column :profiles, :date_of_birth, :date
    
    update "update profiles as p, users as u " +
           "set p.first_name = u.first_name, " +
               "p.last_name = u.last_name, " +
               "p.date_of_birth = u.date_of_birth " +
           "where p.user_id = u.id"

    add_column :tokens, :used, :boolean, :default => false
      
    create_table "logins", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "user_id"
      t.datetime "destroyed_at"
    end

    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :date_of_birth
    remove_column :users, :validation_token
   end

  def self.down
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :validation_token, :string

    update "update profiles as p, users as u " +
           "set u.first_name = p.first_name, " +
               "u.last_name = p.last_name, " +
               "u.date_of_birth = p.date_of_birth " +
           "where p.user_id = u.id"

    remove_column :profiles, :first_name
    remove_column :profiles, :last_name
    remove_column :profiles, :date_of_birth

    remove_column :tokens, :used

    drop_table "logins"
  end
end


