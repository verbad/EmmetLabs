class DirectedRelationship < ActiveRecord::Base
  belongs_to :from, :polymorphic => true
  belongs_to :to, :polymorphic => true
  belongs_to :relationship, :class_name => "Relationship", :foreign_key => "relationship_id"
  belongs_to :category, :class_name => "RelationshipCategory", :foreign_key => "category_id"
  has_many :user_actions, :as => :loggable, :dependent => :destroy

  validates_presence_of :category_id, :message => 'Please choose a category.'
  validates_presence_of :from_id
  validates_presence_of :from_type
  validates_presence_of :to_id
  validates_presence_of :to_type
  validates_presence_of :relationship_id
  validates_uniqueness_of :to_id, :scope => [:to_type, :from_id, :from_type], :message => 'This relationship already exists.'
  validates_uniqueness_of :from_id, :scope => [:from_type, :to_id, :to_type], :message => 'This relationship already exists.'
  
  named_scope :random, lambda { { :offset => rand(count) } }
  
  named_scope :including_to, :include => :to
  
  named_scope :by_endpoint, lambda { |conditions_hash| { :conditions => ['(from_type = :type AND from_id = :id) OR (to_type = :type AND to_id = :id)', conditions_hash] } }
  
  def self.find_by_from_and_to(from, to)
    first(:conditions => 
      {:from_id => from.id, :from_type => from.class.name, :to_id => to.id, :to_type => to.class.name})
  end
  
  def stories
    RelationshipStory.find(:all, :conditions => ["relationship_id = ?", relationship_id])
  end

  def after_destroy
    relationship.destroy
  end

  def after_create
    if relationship.directed_relationships.size == 1
      DirectedRelationship.create(:from => to, :to => from, :category => category.opposite, :relationship => relationship) 
      unless current_user.nil?
        UserAction.create!(:user_id => current_user.id,  # TODO: Figure out how UserAction logs are used, and if recording from/to types is important
                           :action => 'create',
                           :loggable_id => self.to_id,
                           :loggable_type => 'DirectedRelationship' )
        UserAction.create!(:user_id => current_user.id, 
                           :action => 'create',
                           :loggable_id => self.from_id,
                           :loggable_type => 'DirectedRelationship' )  
        UserAction.create!(:user_id => current_user.id, 
                           :action => 'create',
                           :loggable_id => relationship.id,
                           :loggable_type => 'Relationship' )                   
      end                                     
    end
  end

  def validate
    super
    if to == from
      errors.add :to, 'A person cannot be related to him/herself!'
    end
  end

  def to_s
    "#{from} => #{to}"
  end
  
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    stub = {}
    if self.respond_to?(:stub?)
      stub.merge!({:stub => self.stub?}) 
    end
    
    xml.directed_relationship({:id => id, :from_id => from_id, :to_id => to_id, 
                              :from_type => from_type.downcase, :to_type => to_type.downcase}.merge(stub))
  end

  def opposite
    relationship.directed_relationships.find_by_to_id_and_to_type(self.from_id, self.from_type)
  end
  
  def after_initialize 
    @stub = true
  end

  def stub?
    @stub
  end
  
  def stub=(value)
    # keep it strictly boolean
    @stub = value ? true : false
  end
  
end
