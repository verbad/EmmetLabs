class RelationshipCategory < ActiveRecord::Base
  belongs_to :metacategory, :class_name => 'RelationshipMetacategory', :foreign_key => 'metacategory_id'
  belongs_to :db_opposite, :class_name => "RelationshipCategory", :foreign_key => "opposite_id"
  has_many :directed_relationships,  :foreign_key => "category_id", :dependent => :destroy

  validates_presence_of :metacategory

  named_scope :sorted_by_name, :order => :name
  named_scope :parentless, :conditions => ['metacategory_id is null']
  named_scope :symmetric, :conditions => ['opposite_id is null']
  named_scope :non_symmetric, :conditions => ['opposite_id is not null']
  named_scope :eligible_for_opposite, :include => :directed_relationships,
    :conditions => 'opposite_id is null and directed_relationships.id is null'


  def opposite
    db_opposite.nil? ? self : db_opposite
  end

  def to_display_name
    self.metacategory.nil? ? name : "#{self.metacategory.name}: #{name}"
  end

  def make_symmetric
    DirectedRelationship.update_all("category_id = #{self.id}", "category_id = #{self.opposite_id}")
    self.opposite.destroy
    self.update_attributes(:opposite_id => nil)
  end
  
  def migrate_to(target_id)
    target = RelationshipCategory.find(target_id)
    if !target.opposite_id.nil?
      DirectedRelationship.update_all("category_id = #{target.opposite_id}", "category_id = #{self.opposite_id}")
    end
    DirectedRelationship.update_all("category_id = #{target.id}", "category_id = #{self.id}")
  end
  
  
  def self.create_with_opposite(values, opposite = '' )
    begin
      RelationshipCategory.transaction do
        rc = self.create(values)
        unless opposite.empty?
          rc_opposite = self.create(:name => opposite, :opposite_id => rc.id, :metacategory_id => rc.metacategory_id)
          rc.update_attributes(:opposite_id => rc_opposite.id)
        end
        rc
      end
    rescue => exception
    end
  end
  
  


end
