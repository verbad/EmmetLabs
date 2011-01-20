class AddUserAndStorageService < ActiveRecord::Migration
  def self.up
    migrate_plugin('user', 17)
    migrate_plugin('storage_service', 16)

    create_table :sessions, :force => true do |table|
      table.column :sessid, :string, :length => 32
      table.column :data, :text
    end
    add_index :sessions, :sessid
  end

  def self.down
    migrate_plugin('user', 0)
    migrate_plugin('storage_service', 0)

    drop_table(:sessions)
  end
end