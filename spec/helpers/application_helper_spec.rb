require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  
  it "can generate name id pairs for an array of model objects" do
    metacategories = RelationshipMetacategory.find(:all)
    metacategories.should_not be_empty
    display_name_id_pairs = display_name_id_pairs(metacategories)
    
    display_name_id_pairs.each do |pair|
      RelationshipMetacategory.find(pair[1]).to_display_name.should == pair[0]
    end
  end
  
  it "can generate a select tag for an array of model objects" do
    metacategories = RelationshipMetacategory.find(:all)
    metacategories.should_not be_empty
    select_tag = select_related_model('model', 'related_id', metacategories)

    parser = XML::Parser.new
    parser.string = select_tag
    document = parser.parse
    metacategories.each do |object|
      document.find("//option[@value='#{object.id}']").first.content.should == object.name
    end
    first_option = document.find("//option").first
    first_option["value"].should == ""
    first_option.content.should == "---"
  end
end

describe ApplicationHelper do
  it "can generate a human readable directed relationship path" do
    josephine_to_grace = directed_relationships(:josephine_to_grace)
    pretty_directed_relationship_path(josephine_to_grace).should == '/pair/Josephine-Baker_7/Grace-Kelly_12'
  end

  it "can generate a human readable directed relationship XML path" do
    josephine_to_grace = directed_relationships(:josephine_to_grace)
    pretty_directed_relationship_path_xml(josephine_to_grace).should == '/pair/Josephine-Baker_7/Grace-Kelly_12.xml'
  end
end
