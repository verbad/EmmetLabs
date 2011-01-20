class UpgradeUsersTo21 < ActiveRecord::Migration
  def self.up
    migrate_plugin('user', 21)
  end

  def self.down
    migrate_plugin('user', 17)
  end
end
