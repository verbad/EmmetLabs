require File.dirname(__FILE__) + '/../spec_helper'

describe AmazonSearchResultsController, 'handling GET /directed_relationships/1' do
  it_should_behave_like 'login'

  before do
    @directed_relationship = directed_relationships(:janis_to_marilyn)
    @directed_relationship2 = directed_relationships(:jim_to_janis)
    @mock_query = ItemSearchQuery.new(nil, nil, nil)
    @mock_query.should_receive(:perform_query).any_number_of_times.and_return( &lambda {File.open(File.expand_path('spec/fixtures/item_search_query_josephine.xml'), 'r').read} )
    query_should_be_for_relationship(@directed_relationship)
  end

  it "should query amazon for relevant books" do
    get :show, :id => @directed_relationship.to_param
    assigns[:amazon_search_results].size.should == 40
  end

  def query_should_be_for_relationship(relationship)
    AmazonSearchResults::ItemSearchQueryFactory.should_receive(:build).any_number_of_times.with(relationship.from.full_name, 'Books', 1).and_return(@mock_query)
    AmazonSearchResults::ItemSearchQueryFactory.should_receive(:build).any_number_of_times.with(relationship.from.full_name, 'DVD', 1).and_return(@mock_query)
    AmazonSearchResults::ItemSearchQueryFactory.should_receive(:build).any_number_of_times.with(relationship.to.full_name, 'Books', 1).and_return(@mock_query)
    AmazonSearchResults::ItemSearchQueryFactory.should_receive(:build).any_number_of_times.with(relationship.to.full_name, 'DVD', 1).and_return(@mock_query)
  end

end

describe AmazonSearchResultsController do
  it "should require login" do
    get :index
    response.response_code.should == 302
  end
end
