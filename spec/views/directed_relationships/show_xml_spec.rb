require File.dirname(__FILE__) + '/../../spec_helper'

include ApplicationHelper

describe "/directed_relationships/show.xml" do

  before do
    @josephine_to_grace = directed_relationships(:josephine_to_grace)
    @josephine = people(:josephine)
    @grace = people(:grace)
    
    assigns[:directed_relationship] = @josephine_to_grace
    assigns[:from] = @josephine_to_grace.from
    assigns[:to] = @josephine_to_grace.to
    assigns[:people] = @josephine_to_grace.from.relatives_with_primary_photo
    assigns[:directed_relationships] = @josephine_to_grace.from.directed_relations_set

    @controller.template.extend(XmlHelper)
    
    render "/directed_relationships/show.xml.haml"
    xml_parser = XML::Parser.new
    xml_parser.string = response.body
    @document = xml_parser.parse
  end

  it "should be successful" do
    response.should be_success
  end
  
  it "should include the id of the selected directed relationship" do
    @document.find('/wander/selected_directed_relationship/@id').first.value.should == @josephine_to_grace.id.to_s
  end
  
  it "should have Josephine as the from individual and include her relationship to Grace" do
    from_person_element = @document.find("/wander/nodes/person[@id=#{@josephine.id}]").first
    from_person_element.find_first('name').content.should == @josephine.full_name
    from_person_element.find_first('param').content.should == @josephine.to_param
    
    to_person_element = @document.find("/wander/nodes/person[@id=#{@grace.id}]").first
    to_person_element.find_first('name').content.should == @grace.full_name
    to_person_element.find_first('param').content.should == @grace.to_param
  end
end
