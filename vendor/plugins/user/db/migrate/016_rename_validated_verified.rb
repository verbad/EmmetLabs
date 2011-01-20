class RenameValidatedVerified < ActiveRecord::Migration
  def self.up
    rename_column :email_addresses, :validated, :verified
  end

  def self.down
    rename_column :email_addresses, :verified, :validated
  end
end


