class MakeImageAssociationsPolymorphic < ActiveRecord::Migration
  def self.up
    drop_table :images_people
    add_column :images, :imageable_type, :string
    rename_column :images, :person_id, :imageable_id
  end

  def self.down
    create_table(:images_people, :id => false) do |t|
      t.column :person_id, :integer
      t.column :image_id, :integer
    end
  end
end
