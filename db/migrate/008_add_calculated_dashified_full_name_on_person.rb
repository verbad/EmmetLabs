class AddCalculatedDashifiedFullNameOnPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :calculated_dashified_full_name, :string
    add_index :people, :calculated_dashified_full_name

    Person.find(:all).each {|person| person.save!}
  end

  def self.down
    remove_column :people, :calculated_dashified_full_name
  end
end
