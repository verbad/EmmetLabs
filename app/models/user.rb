require 'sortable_columns'
class User < ActiveRecord::Base
  include CanComment
  include SortableColumns

  has_many :user_actions
  
  has_many :created_people, :foreign_key => :author_id, :class_name => 'Person'
  
  has_many :created_relationships, :foreign_key => :author_id, :class_name => 'Relationship'
  
  alias_method :to_display_name, :to_s
  
  def self.most_active_recently
     most_active = UserAction.count(:group => 'user_id', :conditions => ['created_at > ?', 7.days.ago]).max { |a,b| a[1] <=> b[1] }
     most_active.nil? ? User.find(:first, :order => 'created_at DESC') : User.find(most_active[0] )
  end
  
  def people_touched
     people_touched = Person.find_by_sql("select people.*, u.created_at as edit_time from people,user_actions u where u.user_id = #{current_user.id} and u.loggable_type = 'Person' and u.loggable_id = people.id")
     h = Hash.new
     people_touched.each { |r| h[r.id] = r}
     return h.values.sort { |a,b| b.edit_time <=> a.edit_time}
  end
  
  def relationships_touched 
     relationships_touched = Relationship.find_by_sql("select relationships.*, u.created_at as edit_time from relationships,user_actions u where u.user_id = #{current_user.id} and u.loggable_type = 'Relationship' and u.loggable_id = relationships.id")
     h = Hash.new
     relationships_touched.each { |r| h[r.id] = r}
     return h.values.sort { |a,b| b.edit_time <=> a.edit_time}
  end  
end