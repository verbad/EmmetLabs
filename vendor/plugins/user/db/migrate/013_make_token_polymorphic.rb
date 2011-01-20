class MakeTokenPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :tokens, :user_id, :tokenable_id
    add_column :tokens, :tokenable_type, :string
    update "UPDATE tokens SET tokenable_type = 'User'"
  end

  def self.down
    raise IrreversibleMigrationException
  end
end


