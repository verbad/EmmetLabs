class SwitchToActsAsParanoid < ActiveRecord::Migration
  def self.up
    rename_column :logins, :destroyed_at, :deleted_at
  end

  def self.down
    rename_column :logins, :deleted_at, :destroyed_at
  end
end


