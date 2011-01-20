require File.dirname(__FILE__) + '/../spec_helper'

describe Person do
  before(:each) do
    @marilyn = people(:marilyn)
    @family = relationship_metacategories(:family)
    @child = relationship_categories(:child)
    @josephine = people(:josephine)
    @jim = people(:jim)
  end

  it "should concatenate first, middle and last names to build full name" do
    @person = Person.new
    @person.should_receive(:first_name).at_least(:once).and_return('Francis')
    @person.should_receive(:middle_name).and_return('Scott')
    @person.should_receive(:last_name).at_least(:once).and_return('Fitzgerald')
    @person.full_name.should == 'Francis Scott Fitzgerald'
  end

  it "should persist the calculated full name when saved" do
    fitz = people(:fitzgerald)
    fitz.calculated_full_name.should == 'Francis Scott Fitzgerald'
    fitz.first_name = 'Francisco'
    fitz.full_name.should == 'Francisco Scott Fitzgerald'
    fitz.calculated_full_name.should == 'Francis Scott Fitzgerald'
    fitz.calculated_dashified_full_name.should == 'Francis-Scott-Fitzgerald'

    fitz.save!
    fitz.calculated_full_name.should == 'Francisco Scott Fitzgerald'
    fitz.calculated_dashified_full_name.should == 'Francisco-Scott-Fitzgerald'
  end

  it "should concatenate first and last name, if no middle name is present, to build full name" do
    people(:marilyn).full_name.should == 'Marilyn Monroe'
  end

  it "should use common name if no (first and last name) exists" do
    people(:prince_albert).full_name.should == 'Prince Albert of Monaco'
  end

  it "can return a list of people, sorted by full name" do
    sorted_people = Person.sorted_by_full_name
    sorted_people.each_with_index do |person, index|
      unless person == sorted_people.last
        next_person = sorted_people[index+1]
        (person <=> next_person).should == -1
      end
    end
  end

  it "can return a list of people matching a full name substring" do
    results = Person.full_name_like('j')
    results.should_not be_empty
    results.each {|result| result.full_name.downcase.at(0).should == 'j'}
  end

  it "should have directed_relationships and relationships_directed_at_me associations" do
    marilyn_to_jim = directed_relationships(:marilyn_to_jim)
    jim_to_marilyn = directed_relationships(:jim_to_marilyn)

    @marilyn.directed_relationships.should include(marilyn_to_jim)
    @marilyn.directed_relationships.should_not include(jim_to_marilyn)
    @jim.directed_relationships.should include(jim_to_marilyn)

    @marilyn.relationships_directed_at_me.should include(jim_to_marilyn)
    @marilyn.relationships_directed_at_me.should_not include(marilyn_to_jim)
    @jim.relationships_directed_at_me.should include(marilyn_to_jim)
  end

  it "can return all directed relationships falling within a given metacategory" do
      @marilyn.directed_relationships.any? {|rel| rel.category.metacategory == @family}.should be_true

      rels = @marilyn.directed_relationships.in_metacategory(@family)
      rels.should_not be_empty
      rels.each do |rel|
        rel.category.metacategory.should == @family
      end
      rels.length.should < @marilyn.directed_relationships.count
    end

  it "can find no directed relationships NOT belonging to any metacategory" do
    @marilyn.directed_relationships.any? {|rel| rel.category.metacategory.nil?}.should be_false

    rels = @marilyn.directed_relationships.in_no_metacategory
    rels.should be_empty

  end

  it "can lookup all directed relationships in a given category" do
    @marilyn.directed_relationships.any? {|rel| rel.category == @child}.should be_true
    rels = @marilyn.directed_relationships.in_category(@child)
    rels.should_not be_empty
    rels.each do |rel|
      rel.category.should == @child
    end
  end

  it "can determine if it is related to another person" do
    @marilyn.directed_relationships.find_by_to_id(@jim.id).should_not be_nil
    @marilyn.should be_related_to(@jim)
  end


  it "can lookup its supergroups" do
    supergroups = @josephine.relationship_supergroups
    supergroups.should_not be_empty
    supergroups.each do |supergroup|
      supergroup.metacategory.should_not be_nil
      supergroup.relationship_groups.should_not be_empty
      supergroup.relationship_groups.each do |group|
        group.category.metacategory.should == supergroup.metacategory
      end
    end
  end

  it "can should have no entries in groups(categories without metacategories)" do
    groups = @josephine.relationship_groups_not_in_supergroups
    groups.should be_empty
  end

  it "can return a directed relationship to a specific person" do
    directed_relationship = @jim.directed_relationships.to(@marilyn)
    directed_relationship.from.should == @jim
    directed_relationship.to.should == @marilyn
  end

  it "should allow creation of a new person with the same first and last name as an old person" do
    people(:josephine).full_name.should == "Josephine Baker"
    new_person = Person.new(:first_name => "Josephine", :last_name => "Baker", :summary => 'a summary')
    new_person.should be_valid
  end

  it "should destroy associated relationships when it's destroyed" do
    josephine = people(:josephine)
    grace = people(:grace)
    josephine.should be_related_to(grace)
    grace.directed_relationships.count.should == 5

    josephine.destroy
    grace.reload
    grace.directed_relationships.count.should == 4
  end

  it "associates tags with a person upon assignment of a comma-delimited tags string" do
    pending("updated fixtures")
    expected_tags = ['dancer', 'paris', 'banana skirt']
    josephine = people(:josephine)

    josephine.tags = []
    josephine.tags_string = expected_tags.join(', ')

    tags_on_josephine = josephine.tags.map(&:name)
    expected_tags.each do |expected_tag|
      tags_on_josephine.should include(expected_tag)
    end

  end

  it "should replace the entire set of tags upon each assignment of a tag string" do
    pending("updated fixtures")
    @josephine.tags_string = 'a, b, c'
    @josephine.tags.count.should == 3

    @josephine.tags_string = 'a, b'
    @josephine.tags.count.should == 2
  end

  it "should only add unique tags" do
    pending("updated fixtures")
    @josephine.tags_string = 'a, a, a'
    @josephine.tags.count.should == 1
  end

  it "can provide a comma delimited tags string" do
    pending("updated fixtures")
    janis = people(:janis)
    janis.tags.should include(tags(:addict))
    janis.tags.should include(tags(:singer))

    janis.tags_string.should == "addict, singer"
  end

  it "can provide a list of people related to itself" do
    @josephine.relatives.size.should == @josephine.directed_relationships.size
    @josephine.directed_relationships.each {|relationship| @josephine.relatives.should be_include(relationship.to)}
  end

  it "can provide a list of people related to itself including itself" do
    @josephine.with_relatives.size.should == @josephine.directed_relationships.size + 1
    @josephine.with_relatives.should be_include(@josephine)
    @josephine.directed_relationships.each {|relationship| @josephine.with_relatives.should be_include(relationship.to)}
  end

  it "requires a first&last and/or common name to be present" do
    @josephine.should be_valid

    @josephine.first_name = ''
    @josephine.last_name = ''
    @josephine.common_name = ''

    @josephine.full_name.should == ''
    @josephine.should_not be_valid
  end

  it "knows its milestones, in order" do
    @josephine.milestones.should == [
      milestones(:josephine_born), milestones(:josephine_married), milestones(:josephine_graduated), milestones(:josephine_danced), milestones(:josephine_ate_lunch), milestones(:josephine_died)
    ]
  end

  it "should not allow a date of birth after a date of death" do
    @josephine.should be_valid

    set_josephine_lifespan(Date.parse('1900-01-01'), Date.parse('1999-01-01'))
    @josephine.should be_valid

    set_josephine_lifespan(Date.parse('1900-01-01'), Date.parse('1900-01-01'))
    @josephine.should be_valid

    set_josephine_lifespan(Date.parse('1900-01-01'), Date.parse('1899-12-31'))
    @josephine.should_not be_valid

    set_josephine_lifespan(Date.parse('1900-01-01'), Date.parse('1890-01-01'))
    @josephine.should_not be_valid
  end

  it "should find a list of people ordered by relationship count and full name" do
    person_with_no_relationships = people(:no_relationships)
    person_with_no_relationships.directed_relationships.should be_empty
    
    person_with_relationships = people(:janis)
    person_with_relationships.directed_relationships.should_not be_empty
    
    new_person = Person.create!(:common_name => 'new guy', :summary => 'a summary')

    people = Person.sorted_by_relationship_count_and_full_name(1)
    people.should include(person_with_relationships)
    people.should include(person_with_no_relationships)
    people.should include(new_person)
  end

  it "should be able to return all of its relations" do
    jim = people(:jim)
    related_people = jim.all_relations

    expected_relatives = [people(:jim), people(:janis), people(:elvis), people(:marilyn), people(:jfk), people(:abe)]
    expected_relatives.each do |expected_relative|
      related_people.should include(expected_relative)
    end
  end

  it "should know its connected set of relationships" do
    jim = people(:jim)
    jim.directed_relations_set.should have(18).items

   directed_relations_set =
       relationships(:janis_and_marilyn).directed_relationships +
       relationships(:janis_and_jim).directed_relationships +=
       relationships(:jim_and_marilyn).directed_relationships +=
       relationships(:elvis_and_jim).directed_relationships +=
       relationships(:jfk_and_jim).directed_relationships +=
       relationships(:jfk_and_marilyn).directed_relationships +=
       relationships(:abe_and_marilyn).directed_relationships +=
       relationships(:elvis_and_jfk).directed_relationships +=
       relationships(:elvis_and_marilyn).directed_relationships

    directed_relations_set.each do |expected_relationship|
      jim.directed_relations_set.should be_include(expected_relationship)
    end
  end

  it "can find relationship to other person" do
    @jim.directed_relationship_to(@marilyn).should == directed_relationships(:jim_to_marilyn)
  end
  
  it "should return nil when not connected to the other person" do
    @jim.directed_relationship_to(@josephine).should be_nil
  end

  it "can build its name fields from a string" do
    person = Person.from_string(nil)
    ensure_expected_name_fields(person)

    person = Person.from_string('John')
    ensure_expected_name_fields(person, 'John')

    person = Person.from_string('John Smith')
    ensure_expected_name_fields(person, 'John', nil, 'Smith')

    person = Person.from_string('John James Smith')
    ensure_expected_name_fields(person, nil, nil, nil, 'John James Smith')

    person = Person.from_string('John James Smith III')
    ensure_expected_name_fields(person, nil, nil, nil, 'John James Smith III')
  end

  it "knows that summary is required and is at most 150 characters" do
    person = Person.new(:first_name => 'John', :last_name => 'Smith')
    person.should_not be_valid
    person.summary = 'a summary'
    person.should be_valid
    person.summary = 'x'*150
    person.should be_valid
    person.summary = 'x'*151
    person.should_not be_valid
  end

  it "should have a to_param of its dashified_calculated_full_name_<id>" do
    janis = people(:janis)
    janis.to_param.should == 'Janis-Joplin_1'
  end

  it "should find a person by a valid to_param" do
    janis = people(:janis)
    Person.find_by_param(janis.to_param).should == janis
  end

  it "should return nil if the id in the to_param doesn't exist" do
    Person.find_by_param('Janis-Joplin_100000000000000').should be_nil
  end

  it "should return nil if the dashified full name in the to_param doesn't match the id" do
    Person.find_by_param('Janis-Joplin_2').should be_nil
  end

  private

  def ensure_expected_name_fields(person, first_name = nil, middle_name = nil, last_name = nil, common_name = nil)
    person.first_name.should == first_name
    person.middle_name.should == middle_name
    person.last_name.should == last_name
    person.common_name.should == common_name
  end

  def set_josephine_lifespan(birth_date, death_date)
    born = milestones(:josephine_born)
    died = milestones(:josephine_died)
    born.year = birth_date.year
    born.month = birth_date.month
    born.day = birth_date.day
    died.year = death_date.year
    died.month = death_date.month
    died.day = death_date.day
    born.save!
    died.save!
    @josephine.reload
  end

end

describe Person, "when updating" do
  
  it "should capture id of person making the edit" do
    ActiveRecord::Base::current_user = users(:janice)
    janis = people(:janis)
    janis.save
    people(:janis).user_actions.last.user.should == users(:janice)    
  end
  
  it "should create additional edit records for each edit" do
    janice = users(:janice)
    josephine = people(:josephine)
    ActiveRecord::Base::current_user = janice

    josephine.save 
    starting_count = josephine.user_actions.find_all_by_user_id_and_action(janice.id,'update').size
    josephine.save
    josephine.user_actions.find_all_by_user_id_and_action(janice.id,'update').size.should == starting_count + 1
  end
end

