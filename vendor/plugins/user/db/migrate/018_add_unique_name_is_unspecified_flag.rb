class AddUniqueNameIsUnspecifiedFlag < ActiveRecord::Migration
  def self.up
    add_column :users, :unique_name_is_unspecified, :boolean, :default => false
  end

  def self.down
    remove_column :users, :unique_name_is_unspecified
  end
end


