class RemoveUserActionsForUsers < ActiveRecord::Migration
  def self.up
    execute "DELETE FROM user_actions where loggable_type = 'User'"
  end

  def self.down
  end
end
