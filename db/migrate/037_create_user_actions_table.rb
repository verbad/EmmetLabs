class CreateUserActionsTable < ActiveRecord::Migration
  def self.up    
    create_table :user_actions, :force => true do |t|
      t.integer :user_id
      t.integer :loggable_id
      t.string :loggable_type
      t.string :action
      t.timestamps
    end
  end

  def self.down
    drop_table :user_actions
  end
end
