class AmazonSearchResult
  attr_reader :asin, :title, :thumbnail_url, :formatted_price, :author, :sales_rank, :binding
  include Comparable

  def initialize(node)
    @asin = text_node_of(node, 'ASIN')
    @title = text_node_of(node, 'ItemAttributes/Title')
    @author = text_node_of(node, 'ItemAttributes/Author') || text_node_of(node, 'ItemAttributes/Director')
    @thumbnail_url = text_node_of(node, 'MediumImage/URL')
    @binding = text_node_of(node, 'ItemAttributes/Binding')
    @formatted_price = text_node_of(node, 'ItemAttributes/ListPrice/FormattedPrice')
    @sales_rank = text_node_of(node, 'SalesRank').to_i
  end

  def affiliate_url
    "http://www.amazon.com/dp/#{asin}?tag=#{AMAZON_ASSOCIATE_ID}"    
  end

  def <=> (other)
    if self.thumbnail_url and !other.thumbnail_url
      return -1
    elsif !self.thumbnail_url and other.thumbnail_url
      return 1
    end
    self.sales_rank <=> other.sales_rank
  end

  private

  def text_node_of(node, xpath)
    target_node = node.find_first(xpath)
    target_node.nil? ? nil : target_node.content
  end
end
