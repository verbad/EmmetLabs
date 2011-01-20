class AddActsAsParanoidForProfileAndEmailAddress < ActiveRecord::Migration
  def self.up
    add_column :profiles, :deleted_at, :datetime
    add_column :email_addresses, :deleted_at, :datetime
  end

  def self.down
    remove_column :profiles, :deleted_at
    remove_column :email_addresses, :deleted_at
  end
end