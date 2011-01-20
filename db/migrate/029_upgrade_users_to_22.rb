class UpgradeUsersTo22 < ActiveRecord::Migration
  def self.up
    migrate_plugin('user', 22)
  end

  def self.down
    migrate_plugin('user', 21)
  end
end
