class RelationshipGroup
  attr_reader :category, :directed_relationships
  delegate :size, :to => :directed_relationships
  delegate :name, :to => :category

  def initialize(category, directed_relationships)
    @category = category
    @directed_relationships = directed_relationships
  end

end