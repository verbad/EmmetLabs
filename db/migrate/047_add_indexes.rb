class AddIndexes < ActiveRecord::Migration
  def self.up
    # Logged in home page queries
    add_index :assets, :creator_id

    add_index :asset_versions, :asset_id

    add_index :assets_associations, [:associate_type, :associate_id]

    add_index :comments, [:author_type, :author_id]
    add_index :comments, [:topic_type, :topic_id]

    add_index :directed_relationships, :relationship_id
    add_index :directed_relationships, :from_type
    add_index :directed_relationships, :to_type
    add_index :directed_relationships, :to_id

    add_index :email_addresses, :user_id

    add_index :entities, :calculated_dashified_full_name
    add_index :entities, :author_id

    add_index :logins, :user_id

    add_index :milestones, [:node_type, :node_id]
    remove_index :milestones, :name => :index_milestones_on_creator_id
    add_index :milestones, :author_id

    remove_index :people, :name => :index_people_on_creator_id
    add_index :people, :author_id

    add_index :profiles, :user_id

    add_index :relationship_articles, :relationship_id

    add_index :tokens, :tokenable_id
    add_index :tokens, :tokenable_type

    add_index :user_actions, :loggable_id
    add_index :user_actions, :loggable_type
  end

  def self.down
    remove_index :user_actions, :loggable_type
    remove_index :user_actions, :loggable_id

    remove_index :tokens, :tokenable_type
    remove_index :tokens, :tokenable_id

    remove_index :relationship_articles, :relationship_id

    remove_index :profiles, :user_id

    remove_index :people, :author_id
    add_index :people, [:author_id], :name => :index_people_on_creator_id

    remove_index :milestones, :author_id
    add_index :milestones, [:author_id], :name => :index_milestones_on_creator_id
    remove_index :milestones, [:node_type, :node_id]

    remove_index :logins, :user_id

    remove_index :entities, :author_id

    remove_index :entities, :calculated_dashified_full_name

    remove_index :email_addresses, :user_id

    remove_index :directed_relationships, :to_id
    remove_index :directed_relationships, :to_type
    remove_index :directed_relationships, :from_type
    remove_index :directed_relationships, :relationship_id

    remove_index :comments, [:topic_type, :topic_id]
    remove_index :comments, [:author_type, :author_id]

    remove_index :assests_associations, [:associate_type, :associate_id]

    remove_index :asset_versions, :asset_id

    remove_index :assets, :creator_id
  end
end
