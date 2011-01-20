class AmazonSearchResultsController < ApplicationController

  def show
    @directed_relationship = DirectedRelationship.find(params[:id])
    
    @amazon_search_results = AmazonSearchResults.new
    @amazon_search_results.execute_with_directed_relationship(@directed_relationship, 1)
  end

end
