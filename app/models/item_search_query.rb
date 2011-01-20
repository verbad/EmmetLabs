class ItemSearchQuery < Query
  attr_accessor :search_index, :response_group

  SEARCH_INDEX_BOOKS = 'Books'
  SEARCH_INDEX_DVDS = 'DVD'
  AMAZON_BASE_URL = "http://webservices.amazon.com/onca/xml"
  OPERATION_FOR_QUERY = "Operation=ItemSearch"
  AMAZON_SERVICE = "Service=AWSECommerceService"
  SUBSCRIPTION_ID = "SubscriptionId=#{AMAZON_SUBSCRIPTION_ID}"
  SORT = "Sort=salesrank"

  def initialize(keywords, search_index, page)
    @query_url = "#{AMAZON_BASE_URL}?#{OPERATION_FOR_QUERY}&#{AMAZON_SERVICE}&#{SUBSCRIPTION_ID}&#{SORT}&#{search_index_for_query(search_index)}&#{response_group_for_query}&Keywords=#{u(keywords)}&ItemPage=#{page}"
  end

  def execute
    document_from_xml_response(perform_query)
  end

  private

  def strip_amazon_xml_namespace(xml_response)
    xml_response.gsub!(/\ xmlns=\"http:\/\/webservices.amazon.com\/AWSECommerceService\/2005-10-05\"/, '')
  end
  

  def document_from_xml_response(xml_response)
    parser = XML::Parser.new
    xml_response = strip_amazon_xml_namespace(xml_response)
    parser.string = xml_response
    parser.parse
  end

  def search_index_for_query(search_index)
    "SearchIndex=#{search_index}"
  end

  def response_group_for_query
    @response_group.blank? ? 'ResponseGroup=Medium' : "ResponseGroup=#{@response_group}"
  end
end