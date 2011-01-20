class AddSummaryToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :summary, :text
  end

  def self.down
    remove_column :people, :summary
  end
end
