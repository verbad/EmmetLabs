class AddSubscribers < ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.column :email_address, :string
    end
  end

  def self.down
    remove_table :subscribers
  end

end
