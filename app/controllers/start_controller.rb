 class StartController < ApplicationController
  
  def show
    @featured = HomePageRelationship.first.directed_relationship

    @number_of_words = RelationshipArticle.total_word_count + Person.total_word_count
    @number_of_people = Person.count
    
    @random_relationships = DirectedRelationship.random.all(:limit => 5)
    # @random_relationships = (1..5).map { |n| DirectedRelationship.random.first } # alternate: more randomness
    
    @recently = UserAction.recent(8)
    
    @most_active = Person.most_active_recently
    @strongest_networks = Person.sorted_by_relationship_count_and_full_name(1, 5) # page 1, 5 per page
  end

end  
