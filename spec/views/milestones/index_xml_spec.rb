require File.dirname(__FILE__) + '/../../spec_helper'

include ApplicationHelper

describe "/milestones/index.xml" do

  before do
    @josephine = people(:josephine)
    assigns[:node] = @josephine

    @controller.template.extend(XmlHelper)

    render "/milestones/index"
    xml_parser = XML::Parser.new
    xml_parser.string = response.body
    @document = xml_parser.parse
  end

  it "should include the id of the person" do
    response.should be_success
    timeline_node = @document.find('/timeline').first
    timeline_node['node_id'].should == @josephine.id.to_s
    milestone_nodes = timeline_node.find('milestone')
    milestone_nodes.size.should == @josephine.milestones.size
    milestone_nodes.first.find_first('date/year').content.should == '1906'
    milestone_nodes.first.find_first('date/month').content.should == '6'
    milestone_nodes.first.find_first('date/day').content.should == '3'
    milestone_nodes.first.find_first('date/estimate').content.should == 'false'
    milestone_nodes.first.find_first('name').content.should == 'Born in Missouri'
  end

end
