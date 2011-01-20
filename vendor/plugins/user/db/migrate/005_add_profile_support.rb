class AddProfileSupport < ActiveRecord::Migration
  def self.up
    unless table_exists?("profiles")
      create_table "profiles", :force => true do |t|
        t.integer "user_id"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end

    unless table_exists?("profile_answers")
      create_table "profile_answers", :force => true do |t|
        t.integer "profile_id"
        t.integer "question_id"
        t.string "value"
      end
    end

    unless table_exists?("profile_question_categories")
      create_table "profile_question_categories", :force => true do |t|
        t.string "name",  :limit => 64
        t.string "display_name"
        t.integer "sort_order"
      end
    end

    unless table_exists?("profile_questions")
      create_table "profile_questions", :force => true do |t|
        t.string "type"
        t.string "name", :limit => 64, :default => "", :null => false
        t.string "display_name"
        t.integer "category_id"
        t.integer "sort_order"
      end
    end
  end

  def self.down
    drop_table "profile_questions"
    drop_table "profile_question_categories"
    drop_table "profile_answers"
    drop_table "profiles"
  end

  
end