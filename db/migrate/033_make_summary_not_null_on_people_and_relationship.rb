class MakeSummaryNotNullOnPeopleAndRelationship < ActiveRecord::Migration
  def self.up
    execute "update people set summary='Summary goes here' where summary is null or length(summary) = 0"
    execute "update relationships set summary='Summary goes here' where summary is null or length(summary) = 0"
    change_column :people, :summary, :string, :null => false
    change_column :relationships, :summary, :string, :null => false
  end

  def self.down
    change_column :people, :summary, :string, :null => true
    change_column :relationships, :summary, :string, :null => true
    execute "update people set summary=null where summary = 'Summary goes here'"
    execute "update relationships set summary=null where summary = 'Summary goes here'"
  end
end
