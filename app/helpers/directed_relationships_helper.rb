module DirectedRelationshipsHelper
  def directed_relationship_title(directed_relationship)
    mab = Markaby::Builder.new do
      div.directed_relationship_title! do
        h1 directed_relationship.from.full_name + ' & ' + directed_relationship.to.full_name
      end
    end
  end
  
  def categories(directed_relationship)
    category = directed_relationship.category
    opposite = category.opposite
    
    if category == opposite
      return category.name.pluralize
    else
      return opposite.name + ' & ' + category.name
    end
  end
end
