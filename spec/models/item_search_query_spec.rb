require File.dirname(__FILE__) + '/../spec_helper'

describe ItemSearchQuery do
  it "should make a call to amazon API and return valid XML" do
    item_search_query = ItemSearchQuery.new('josephine baker', 'Books', 1)
    xml_response = item_search_query.execute
    xml_response.should_not be_nil
    xml_response.find('/ItemSearchResponse/Items/Request/IsValid').first.content.downcase.should == 'true'
    xml_response.find('/ItemSearchResponse/Items/TotalResults').first.content.should_not == 0
  end
end