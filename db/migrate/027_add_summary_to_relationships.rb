class AddSummaryToRelationships < ActiveRecord::Migration
  def self.up
    add_column :relationships, :summary, :text
  end

  def self.down
    remove_column :relationships, :summary
  end
end
