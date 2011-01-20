class MakeUsersTermsOfServiceNullable < ActiveRecord::Migration
  def self.up
    add_column :users, :terms_of_service_id_temp, :integer, :null => true
    execute 'update users set terms_of_service_id_temp = terms_of_service_id'
    remove_column :users, :terms_of_service_id
    add_column :users, :terms_of_service_id, :integer, :null => true
    execute 'update users set terms_of_service_id = terms_of_service_id_temp'
    remove_column :users, :terms_of_service_id_temp
  end

  def self.down
    raise IrreversibleMigration
  end
end
