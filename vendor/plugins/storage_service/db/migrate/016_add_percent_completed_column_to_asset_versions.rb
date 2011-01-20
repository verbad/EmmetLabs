class AddPercentCompletedColumnToAssetVersions < ActiveRecord::Migration
  def self.up
    add_column :asset_versions, :percent_completed, :float
    add_column :asset_versions, :state_info, :string
    insert("INSERT INTO asset_version_states
      VALUES (3, 'encoding', 'Encoding'), (4, 'problem', 'Problem')")
  end

  def self.down
    remove_column :asset_versions, :percent_completed
    remove_column :asset_versions, :state_info
  end

end