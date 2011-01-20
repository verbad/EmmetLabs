class RenameEmailAddressesEmailAddressToAddress < ActiveRecord::Migration
  def self.up
    rename_column :email_addresses, :email_address, :address
  end

  def self.down
    rename_column :email_addresses, :address, :email_address
  end
end


