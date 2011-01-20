class RelationshipMetacategory < ActiveRecord::Base
  has_many :categories, :class_name => "RelationshipCategory", :foreign_key => "metacategory_id", :order => :name
  named_scope :sorted_by_name, :order => :name

  def to_display_name
    name
  end

end
