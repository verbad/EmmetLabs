class AddHomePageRelationships < ActiveRecord::Migration
  def self.up
    create_table :home_page_relationships do |t|
      t.column :directed_relationship_id, :integer
    end
    HomePageRelationship.create(:directed_relationship_id => 53)
  end

  def self.down
    drop_table :home_page_relationships
  end
end
