class AddAssetsVersions < ActiveRecord::Migration
  def self.up
    create_table :assets_versions do |t|
      t.column :version, :string
      t.column :asset_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :state_id, :integer
    end

    create_table :asset_version_states do |t|
      t.column :name, :string
      t.column :display_name, :string
    end

    insert %{
      INSERT INTO asset_version_states
      VALUES (1, 'completed', 'Completed'), (2, 'pending', 'Pending')
    }
  end

  def self.down
    drop_table :assets_versions
    drop_table :asset_version_states
  end
end