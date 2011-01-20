require File.dirname(__FILE__) + '/../../spec_helper'

#TODO(eh/rd) - changing the order of the specs in this file seems to cause a "Bus Error" - we can't figure out why/when this happens

describe "/network/show.xml" do
  include ActionView::Helpers::AssetTagHelper
  
  before do
    @josephine = people(:josephine)
    assigns[:target_person] = @josephine
    assigns[:people] = @josephine.with_relatives

    @controller.template.extend(XmlHelper)

    render "/network/show.rxml"
    xml_parser = XML::Parser.new
    xml_parser.string = response.body
    @document = xml_parser.parse
  end

  it "should be successful" do
    response.should be_success
  end

  it "should have a 'target' element pointing to Josephine" do
    person_xml = @document.find("/network/target/@id").first.value.should == @josephine.id.to_s
   end


=begin
it "should only include relatives of the target person" do
    people_xml = @document.find("//person")

    expected_people = @josephine.with_relatives
    expected_people.size.should == people_xml.size
    people_xml.each do |person_xml|
      param = person_xml.find_first('param').content
      relative = Person.find_by_param(param)
      relative.should_not be_nil
      expected_people.should be_include(relative)
    end
  end

  it "should have a 'category_supergroup' element for all relationships that live in a metacategory" do
    family_metacategory = relationship_metacategories(:family)
    relationships_to_family = @josephine.directed_relationships.in_metacategory(family_metacategory)
    assert relationships_to_family.size > 0

    family_metacategory_xml = @document.find("/network/relationship_supergroup[@metacategory_name='Family']").first
    family_metacategory_xml.should_not be_nil

    relationships_to_family.each do |rel|
      person_xml = @document.find("/network/people/person[@id=#{rel.to.id}]").first
      person_xml.should_not be_nil
      family_metacategory_xml.find("/relationship_group/directed_relationship[@id=#{rel.id}]").should_not be_nil
    end

  end

  it "should have a 'directed_relationship' element for every relationship, grouped by its category" do
    @josephine.directed_relationships.each do |directed_rel|
      directed_relationship_xml = @document.find("/network//relationship_group/directed_relationship[@id=#{directed_rel.id}]").first
      directed_relationship_xml.should_not be_nil

      to_person = directed_rel.to
      person_xml = @document.find("/network/people/person[@id=#{@josephine.id}]").first
      person_xml.should_not be_nil

      relationship_group_xml = directed_relationship_xml.parent
      relationship_group_xml["category_name"].should == directed_rel.category.name
      relationship_group_xml["category_id"].should == directed_rel.category.id.to_s
    end
  end
=end


end
  