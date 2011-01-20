require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Entity do
  before do
    @person = people(:janis)
    @entity = Entity.new

    @valid_attributes = {
      :full_name => "value for full_name",
      :calculated_dashified_full_name => "value for calculated_dashified_full_name",
      :backgrounder => "value for backgrounder",
      :summary => "value for summary",
      :further_reading => "value for further_reading",
      :author_id => 1,
      :also_known_as => "value for also_known_as"
    }
  end

  it "should create a new instance given valid attributes" do
    Entity.create!(@valid_attributes)
  end

  describe "#migrate_from_person!" do
    before do
      Entity.stub!(:new).and_return(@entity)
    end

    it "should map the Person's attributes to a new Entity's attributes" do
      now = Time.now  # HACK: make the Timestamp match the Date from the fixture
      @person.stub!(:updated_at).and_return(now)
      @entity.stub!(:updated_at).and_return(now)

      mapped_attributes = Person::PersonToEntityAttributesMap.inject({}) do |memo, keyval|
        memo[keyval.last] = @person.send(keyval.first); memo
      end
      Entity.migrate_from_person!(@person)
      Person::PersonToEntityAttributesMap.each do |person_method, entity_method|
        @entity.send(entity_method).should == @person.send(person_method)
      end
    end

    it "should migrate the associations from person" do
      @entity.should_receive(:migrate_associations_from_person!)
      Entity.migrate_from_person!(@person)
    end
  end

  describe "#migrate_associations_from_person!" do
    it "should assign all direct associations from the Person to the Entity" do
      @mock_item = mock('AssociatedActiveRecord', :null_object => true)
      Entity.reflect_on_all_associations.each do |assoc|
        @entity.should_receive("#{assoc.name}=").with(@person.send(assoc.name)) unless assoc.through_reflection
      end
      @entity.should_receive("assets=").with(@person.assets)
      #@entity.should_receive("taggings=").with(@person.tags)
      
      @entity.migrate_associations_from_person!(@person)
    end

    it "should transfer all associated AR's from the Person to the Entity" do
      # It now needs to be valid, since the method must save & reload to fix tags
      entity = Entity.create!(@valid_attributes)
      entity.migrate_associations_from_person!(@person)
      Entity.reflect_on_all_associations.inject([]) do |records, assoc|
        entity.send(assoc.name).should == @person.send(assoc.name)
      end
    end
  end
end
