class AddEmailAddresses < ActiveRecord::Migration
  def self.up
    create_table "email_addresses", :force => true do |t|
      t.string "email_address"
      t.integer "user_id"
      t.boolean "validated"
      t.boolean "primary"
    end
    emails = select_all <<-SQL
      SELECT id, email_address, account_validated FROM users
    SQL
    emails.each do |email_address|
      insert <<-SQL
        INSERT INTO email_addresses (`email_address`, `user_id`, `validated`, `primary`) VALUES ('#{email_address['email_address']}', #{email_address['id']}, #{email_address['account_validated']}, 1)
      SQL
    end
    remove_column :users, :email_address
    remove_column :users, :account_validated
  end

  def self.down
    raise IrreversibleMigrationException
  end
end


