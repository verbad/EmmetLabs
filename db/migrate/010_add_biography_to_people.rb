class AddBiographyToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :biography, :string
  end

  def self.down
    remove_column :people, :biography
  end
end
