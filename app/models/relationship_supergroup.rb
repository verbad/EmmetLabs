class RelationshipSupergroup
  attr_reader :metacategory, :relationship_groups
  delegate :name, :to => :metacategory

  def initialize(metacategory, relationship_groups)
    @metacategory = metacategory
    @relationship_groups = relationship_groups
  end

  def size
    @relationship_groups.inject(0) {|count, group| count = count + group.size}
  end
end