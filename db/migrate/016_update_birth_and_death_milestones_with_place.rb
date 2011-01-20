class UpdateBirthAndDeathMilestonesWithPlace < ActiveRecord::Migration
  def self.up
    people = Person.find(:all)
    people.each do |person|
      unless person.place_of_birth.nil?
        execute "update milestones set name = '#{person.place_of_birth}' where milestones.type_id=1 and milestones.person_id=#{person.id}"
      end
      unless person.place_of_death.nil?
        execute "update milestones set name = '#{person.place_of_death}' where milestones.type_id=2 and milestones.person_id=#{person.id}"
      end
    end

    remove_column :people, :place_of_birth
    remove_column :people, :place_of_death
  end

  def self.down
    raise IrreversibleMigration
  end
end
