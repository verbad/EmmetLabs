class ChangePersonBirthAndDeathDateToMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestone_types do |t|
      t.column :name, :string
      t.column :display_name, :string
    end

    execute "insert into milestone_types (name, display_name) values ('birth', 'Born in')"
    execute "insert into milestone_types (name, display_name) values ('death', 'Died in')"

    add_column :milestones, :type_id, :integer

    people = Person.find(:all)
    people.each do |person|
      unless person.date_of_birth.nil?
        execute "insert into milestones (person_id, year, month, day, type_id) values (#{person.id}, #{person.date_of_birth.year}, #{person.date_of_birth.month}, #{person.date_of_birth.day}, #{Milestone::Type[:birth].id})"
      end
      unless person.date_of_death.nil?
        execute "insert into milestones (person_id, year, month, day, type_id) values (#{person.id}, #{person.date_of_death.year}, #{person.date_of_death.month}, #{person.date_of_death.day}, #{Milestone::Type[:death].id})"
      end
    end

    remove_column :people, :date_of_birth
    remove_column :people, :date_of_death
  end

  def self.down
    raise IrreversibleMigration
  end
end
