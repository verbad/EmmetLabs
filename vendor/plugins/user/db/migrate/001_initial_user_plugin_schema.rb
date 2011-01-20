class InitialUserPluginSchema < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string "password_reset_token"
      t.datetime "password_reset_expiration"
      t.string "email_address"
      t.string "encrypted_password"
      t.string "first_name"
      t.string "last_name"
      t.datetime "date_of_birth"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "last_login"
      t.string "unique_name"
    end

    add_index(:users, [:unique_name], :unique => true)
    add_index(:users, [:email_address], :unique => true)

    create_table "auto_logins", :force => true do |t|
      t.string "token"
      t.integer "user_id"
    end
  end

  def self.down
    drop_table :users
  end
end
