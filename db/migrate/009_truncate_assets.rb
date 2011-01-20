class TruncateAssets < ActiveRecord::Migration
  def self.up
    execute 'truncate table assets_associations'
    execute 'truncate table asset_versions'
    execute 'truncate table assets'
  end

  def self.down
    raise IrreversibleMigrationException
  end
end
