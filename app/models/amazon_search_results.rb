require "query"
require "item_search_query"

class AmazonSearchResults
  def initialize
    @results = []
    @keywords = []
    @queries = []
  end

  def query_time
    (@queries.collect {|query| query.query_time}).max
  end

  def execute_with_directed_relationship(relationship, page_number = 1)
    from_results = []
    to_results = []
    from_thread = Thread.new(relationship.from.full_name, from_results, page_number) do |keywords, array, page_number|
      execute_with_keywords(keywords, array, page_number)
    end
    to_thread = Thread.new(relationship.to.full_name, to_results, page_number) do |keywords, array, page_number|
      execute_with_keywords(keywords, array, page_number)
    end
    from_thread.join
    to_thread.join

    from_results.sort!
    to_results.sort!

    @results << from_results.shift unless from_results.empty?
    @results << to_results.shift unless to_results.empty?

    outstanding = from_results + to_results
    outstanding.sort!

    @results.concat outstanding
  end

  def keywords
    @keywords.join(', ')
  end

  protected
  
  def method_missing(method, *args, &block)
    @results.send(method.to_sym, *args, &block)
  end

  class ItemSearchQueryFactory
    def self.build(keywords, search_index, page_number)
      ItemSearchQuery.new(keywords, search_index, page_number)
    end
  end

  private

  def execute_with_keywords(keywords, collecting_array, page_number = 1)
    @keywords << keywords

    functor = lambda do |keywords, search_index, page_number|
      query = ItemSearchQueryFactory.build(keywords, search_index, page_number)
      begin
        collecting_array.concat parse(query.execute)
      rescue
      end
      @queries << query
    end

    book_thread = Thread.new(keywords, ItemSearchQuery::SEARCH_INDEX_BOOKS, page_number, &functor)
    dvd_thread = Thread.new(keywords, ItemSearchQuery::SEARCH_INDEX_DVDS, page_number, &functor)
    book_thread.join
    dvd_thread.join
    collecting_array
  end

  def parse(document)
    results = []
    item_nodes = document.find('/ItemSearchResponse/Items/Item')
    item_nodes.each {|node| results << AmazonSearchResult.new(node)}
    results
  end

end