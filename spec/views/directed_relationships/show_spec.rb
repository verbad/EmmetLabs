require File.dirname(__FILE__) + '/../../spec_helper'

describe "/directed_relationships/show" do
  it "should work" do
    template.assigns[:directed_relationship_history] = []
    template.assigns[:directed_relationship] = directed_relationships(:jim_to_janis)
    template.assigns[:from] = assigns[:directed_relationship].from
    template.assigns[:to] = assigns[:directed_relationship].to
    template.assigns[:people] = Person.find(:all)
    template.assigns[:directed_relationships] = DirectedRelationship.find(:all)
    render "/directed_relationships/show.xml.haml"
    response.should be_success
  end
end