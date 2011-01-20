class YearOfBirthIsADate < ActiveRecord::Migration
  def self.up
    change_column(:users, :date_of_birth, :date)
  end

  def self.down
    change_column(:users, :date_of_birth, :datetime)
  end
end