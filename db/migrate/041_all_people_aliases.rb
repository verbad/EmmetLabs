class AllPeopleAliases < ActiveRecord::Migration
  def self.up
    add_column :people, :aliases, :string
    execute "UPDATE people set aliases = common_name"
    
  end

  def self.down
    remove_column :people, :aliases
  end
end
