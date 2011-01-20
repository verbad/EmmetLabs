class AddSaltAndOtherStuff < ActiveRecord::Migration
  def self.up
    add_column(:users, :salt, :string)
    remove_column(:users, :last_login)
    remove_column(:users, :password_reset_token)
    remove_column(:users, :password_reset_expiration)

    create_table(:user_activities) do |t|
      t.integer :user_id
      t.string :type
      t.datetime :created_at
    end

    create_table(:tokens) do |t|
      t.integer :user_id
      t.string :type
      t.string :token
      t.datetime :expires_at
      t.datetime :created_at
    end

    drop_table(:auto_logins)
  end

  def self.down
    drop_table(:user_activities)
    drop_table(:tokens)

    remove_column(:users, :salt)
    add_column(:users, :last_login, :datetime)
    add_column(:users, :password_reset_token, :string)
    add_column(:users, :password_reset_expiration, :datetime)

    create_table "auto_logins", :force => true do |t|
      t.string "token"
      t.integer "user_id"
    end
  
  end
end