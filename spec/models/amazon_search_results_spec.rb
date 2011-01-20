require File.dirname(__FILE__) + '/../spec_helper'

describe AmazonSearchResults do

  before do
    @mock_query = ItemSearchQuery.new(nil, nil, nil)
    @mock_query.should_receive(:perform_query).any_number_of_times.and_return(&lambda {File.open(File.expand_path('spec/fixtures/item_search_query_josephine.xml'), 'r').read})
    @results = AmazonSearchResults.new
  end

  it "should build correct keywords from directed relationship" do
    relationship = directed_relationships(:josephine_to_grace)
    AmazonSearchResults::ItemSearchQueryFactory.should_receive(:build).with('Josephine Baker', 'Books', 2).and_return(@mock_query)
    AmazonSearchResults::ItemSearchQueryFactory.should_receive(:build).with('Josephine Baker', 'DVD', 2).and_return(@mock_query)
    AmazonSearchResults::ItemSearchQueryFactory.should_receive(:build).with('Grace Kelly', 'Books', 2).and_return(@mock_query)
    AmazonSearchResults::ItemSearchQueryFactory.should_receive(:build).with('Grace Kelly', 'DVD', 2).and_return(@mock_query)
    @results.execute_with_directed_relationship(relationship, 2)
    assert_correct_results
  end

  def assert_correct_results
    @results.each {|result| result.class.should == AmazonSearchResult}
    @results.first.asin.should_not be_empty
  end

end