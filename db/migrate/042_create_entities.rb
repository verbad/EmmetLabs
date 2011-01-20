class CreateEntities < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|
      t.string :full_name
      t.string :calculated_dashified_full_name
      t.text :backgrounder
      t.string :summary
      t.text :further_reading
      t.references :author
      t.string :also_known_as

      t.timestamps
    end
  end

  def self.down
    drop_table :entities
  end
end
