class BreakOutNameFieldsOnPeople < ActiveRecord::Migration
  def self.up
    rename_column :people, :name, :common_name
    add_column :people, :first_name, :string
    add_column :people, :middle_name, :string
    add_column :people, :last_name, :string
    add_column :people, :calculated_full_name, :string
    add_index :people, :calculated_full_name
    add_column :people, :place_of_birth, :string
    add_column :people, :place_of_death, :string
    add_column :people, :date_of_birth, :date
    add_column :people, :date_of_death, :date
  end

  def self.down
    remove_column :people, :first_name
    remove_column :people, :middle_name
    remove_column :people, :last_name
    rename_column :people, :common_name, :name
    remove_column :people, :place_of_birth
    remove_column :people, :place_of_death
    remove_column :people, :date_of_birth
    remove_column :people, :date_of_date
  end
end
