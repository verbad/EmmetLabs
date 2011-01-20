class AddValidationSupport < ActiveRecord::Migration
  def self.up
    add_column("users", "validation_token", :string)
    add_column("users", "account_validated", :boolean, :default => false)
    execute "UPDATE users SET account_validated = 1"
  end

  def self.down
    remove_column("users", "account_validated")
    remove_column("users", "validation_token")
  end
end
