class InstallCommentsPlugin < ActiveRecord::Migration
  def self.up
    migrate_plugin('comments', 3)
  end

  def self.down
    migrate_plugin('comments', 0)
  end
end