class AddTimestampColumnsToUserTables < ActiveRecord::Migration
  def self.up
    add_column :email_addresses, :updated_at, :datetime
    add_column :email_addresses, :created_at, :datetime
    add_column :tokens, :updated_at, :datetime
  end

  def self.down
    remove_column :email_addresses, :created_at
    remove_column :email_addresses, :updated_at
    remove_column :tokens, :updated_at
  end
end


