class Milestone < ActiveRecord::Base
  belongs_to :node, :polymorphic => :true
  has_enumerated :type, :class_name => 'Milestone::Type', :foreign_key => :type_id
  validates_numericality_of :year, :message => 'Invalid year'
  before_validation :multiply_year

  def validate
    super
    if errors[:year].nil?
      if month.nil? and !day.nil?
        errors.add(:month, 'Must specify a month if a day is specified')
      elsif fuzzy_date.future?
        errors.add(:year, "Date must be in the past")
      end
    end

    unless type.nil?
      matching = Milestone.find_by_type_id_and_node_id_and_node_type(type.id, node.id, node.class.name)
      unless (matching.nil? or self == matching)
        errors.add(:type, "This #{node.class.name.downcase} already has a milestone of this type")
      end
    end

  end

  def <(other)
    fuzzy_date < other.fuzzy_date
  end

  def display_name
    return name if type.nil?
    type.display_name + ' ' + name
  end

  def year_multiplier=(multiplier)
    @year_multiplier = multiplier.to_i
  end

  def blank?
    year.blank? && month.blank? && day.blank?
  end
  
  class Type < ActiveRecord::Base
    set_table_name :milestone_types
    acts_as_enumerated
  end

  protected

  def fuzzy_date
    Date.new(year, month || 1, day || 1)
  end

  private

  def multiply_year
    self.year = self.year * @year_multiplier if self.year.to_i != 0 and @year_multiplier
    true
  end

end