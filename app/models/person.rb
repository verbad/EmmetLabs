class Person < ActiveRecord::Base
  include EntityAttributes

  before_validation :calculate_full_name

  named_scope :full_name_like, lambda { |name| {:conditions => ['calculated_full_name like ?', "%#{name}%"]} }

  def self.from_string(string) #TODO: implement in Entity
    return Person.new if string.nil?
    values = string.split(' ')
    hash = {}
    case values.size
    when 1: hash[:first_name] = values.first
    when 2: hash[:first_name] = values.first; hash[:last_name] = values.last
    else
      hash[:common_name] = string
    end
    Person.new(hash)
  end

  def full_name
    return [first_name, middle_name, last_name].select {|name| !name.blank?}.join(' ') unless first_name.blank? or last_name.blank?
    return common_name
  end

  def calculate_full_name
    new_full_name = self.full_name
    self.calculated_full_name = new_full_name
    self.calculated_dashified_full_name = new_full_name.nil? ? nil : new_full_name.dashify
  end

  def validate
    super
    unless birth_milestone.nil? or death_milestone.nil?
      if death_milestone < birth_milestone
        errors.add :date_of_date, "Date of death cannot be before date of birth"
      end
    end
  end

  def birth_milestone
    milestone_of_type(Milestone::Type[:birth])
  end

  def death_milestone
    milestone_of_type(Milestone::Type[:death])
  end
  
  PersonToEntityAttributesMap = {
    :calculated_full_name => :full_name,
    :biography => :backgrounder,
    :aliases => :also_known_as,
    # the below map straight across
    :calculated_dashified_full_name => :calculated_dashified_full_name,
    :summary => :summary,
    :created_at => :created_at,
    :updated_at => :updated_at,
    :author_id => :author_id
  }
  
  def attributes_for_entity
    entity_attributes = {}
    PersonToEntityAttributesMap.each do |person_method, entity_method|
      entity_attributes[entity_method] = send(person_method)
    end
    entity_attributes
  end
  
  def self.total_word_count 
    all(:select => :biography).inject(0) { |sum, p| sum += p.word_count }
  end
  
  def word_count
    (biography || '').split.size
  end
  
  private

  def milestone_of_type(type)
    milestones.select {|milestone| milestone.type == type}.first
  end
end
