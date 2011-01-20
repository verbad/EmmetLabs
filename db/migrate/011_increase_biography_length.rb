class IncreaseBiographyLength < ActiveRecord::Migration
  def self.up
    change_column :people, :biography, :text 
  end

  def self.down
    change_column :people, :biography, :string
  end
end
