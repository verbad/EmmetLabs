class AddPositionsToProfile < ActiveRecord::Migration
  def self.up
    add_column :profile_answers, "position", :integer unless self.column_exists?(:profile_answers, :position)
    add_column :profile_questions, "position", :integer unless self.column_exists?(:profile_questions, :position)
    add_column :profile_question_categories, "position", :integer unless self.column_exists?(:profile_question_categories, :position)
  end

  def self.down
    remove_column :profile_answers, "position"
    remove_column :profile_questions, "position"
    remove_column :profile_question_categories, "position"
  end
end