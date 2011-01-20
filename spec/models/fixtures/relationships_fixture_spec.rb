require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "Bidirectional relationships" do
  it "should be defined for our small dataset" do
    ensure_related(:jim, :janis, :lover, :lover, 1)
    ensure_related(:elvis, :jim, :mentor, :student, 1)
    ensure_related(:jim, :marilyn, :colleague, :colleague, 1)
    ensure_related(:jfk, :jim, :enemy, :enemy, 1)
    ensure_related(:jfk, :marilyn, :child, :parent, 2)
    ensure_related(:marilyn, :janis, :friend, :friend, 1)
    ensure_related(:marilyn, :elvis, :cousin, :cousin, 1)
    ensure_related(:jfk, :elvis, :relative, :relative, 1)
    ensure_related(:marilyn, :abe, :sibling, :sibling, 1)
  end
  
  it "should be defined for Josephine" do
    ensure_related(:josephine, :grace, :friend, :friend, 1)
    ensure_related(:josephine, :fitzgerald, :friend, :friend, 0)
    ensure_related(:josephine, :hemingway, :friend, :friend, 0)
    ensure_related(:josephine, :hughes, :friend, :friend, 0)
    ensure_related(:josephine, :picasso, :friend, :friend, 0)
    ensure_related(:josephine, :alex, :associate, :associate, 0)
    ensure_related(:josephine, :winchell, :associate, :associate, 0)
    ensure_related(:josephine, :mcdonald, :child, :parent, 0)
    ensure_related(:josephine, :carson, :child, :parent, 0)
    ensure_related(:josephine, :akio, :parent, :child, 0)
    ensure_related(:josephine, :janot, :parent, :child, 0)
    ensure_related(:josephine, :luis, :parent, :child, 0)
    ensure_related(:josephine, :jarry, :parent, :child, 0)
    ensure_related(:josephine, :jean_claude, :parent, :child, 0)
    ensure_related(:josephine, :moise, :parent, :child, 0)
    ensure_related(:josephine, :brahim, :parent, :child, 0)
    ensure_related(:josephine, :marianne, :parent, :child, 0)
    ensure_related(:josephine, :koffi, :parent, :child, 0)
    ensure_related(:josephine, :mara, :parent, :child, 0)
    ensure_related(:josephine, :noel, :parent, :child, 0)
    ensure_related(:josephine, :stellina, :parent, :child, 0)
    ensure_related(:josephine, :brady, :partner, :partner, 0)
    ensure_related(:josephine, :abatino, :partner, :partner, 0)
    ensure_related(:josephine, :wells, :partner, :partner, 0)
    ensure_related(:josephine, :baker, :partner, :partner, 0)
    ensure_related(:josephine, :bouillion, :partner, :partner, 0)
  end

  it "should be defined for Grace" do    
    ensure_related(:grace, :josephine, :friend, :friend, 1)
    ensure_related(:grace, :prince_rainier, :partner, :partner, 0)
    ensure_related(:grace, :jackie_o, :friend, :friend, 0)
    ensure_related(:grace, :angela_martin, :friend, :friend, 0)
    ensure_related(:grace, :rock_hudson, :associate, :associate, 0)
  end
  
  it "should be defined for Prince Rainier" do
    ensure_related(:prince_rainier, :prince_albert, :associate, :associate, 0)
  end
  
  it "should be defined for Langston Hughes" do
    ensure_related(:hughes, :garvey, :associate, :associate, 1)
  end

  def ensure_related(person_a_symbol, person_b_symbol, b_to_a_category_symbol, a_to_b_category_symbol, num_stories)
    person_names = [person_a_symbol.to_s, person_b_symbol.to_s].sort

    relationship_symbol = person_names.join('_and_').to_sym
    directed_relationship_for_a_symbol = "#{person_a_symbol}_to_#{person_b_symbol}".to_sym
    directed_relationship_for_b_symbol = "#{person_b_symbol}_to_#{person_a_symbol}".to_sym

    relationship = relationships(relationship_symbol)
    person_a = people(person_a_symbol)
    person_b = people(person_b_symbol)
    b_to_a_category = relationship_categories(b_to_a_category_symbol)
    a_to_b_category = relationship_categories(a_to_b_category_symbol)
    
    directed_relationship_for_a = directed_relationships(directed_relationship_for_a_symbol)
    directed_relationship_for_b = directed_relationships(directed_relationship_for_b_symbol)
    ensure_direct_relationship(directed_relationship_for_a, relationship, person_a, person_b, a_to_b_category)
    ensure_direct_relationship(directed_relationship_for_b, relationship, person_b, person_a, b_to_a_category)
    
    # Every one of these bidirectional relationships should have at least one story
    num_stories.times do |story_indx|
      story = relationship_stories("#{relationship_symbol}_#{story_indx}".to_sym)
      story.should_not be_nil
      story.relationship.should == relationship
      relationship.stories.should include(story)
    end
  end

  def ensure_direct_relationship(directed_relationship, expected_relationship, expected_from, expected_to, expected_relationship_category)
    expected_to.should_not be_nil
    expected_from.should_not be_nil
    expected_relationship.should_not be_nil

    directed_relationship.should_not be_nil
    directed_relationship.relationship.should == expected_relationship
    expected_relationship.directed_relationships.should include(directed_relationship)
    expected_from.directed_relationships.should include(directed_relationship)
    directed_relationship.from.should == expected_from
    directed_relationship.to.should == expected_to
    directed_relationship.category.should == expected_relationship_category
  end

end
