class RenameTarget < ActiveRecord::Migration
  def self.up
    rename_column :comments, :target_id, :topic_id
    rename_column :comments, :target_type, :topic_type
  end

  def self.down
    rename_column :comments, :topic_id, :target_id
    rename_column :comments, :topic_type, :target_type
  end
end
