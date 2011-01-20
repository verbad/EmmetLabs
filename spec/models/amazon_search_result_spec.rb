require File.dirname(__FILE__) + '/../spec_helper'

describe AmazonSearchResult do
  it "should create an amazon search result given a valid item node" do
    xml_string = File.open(File.expand_path('spec/fixtures/item_node.xml'), 'r').read
    parser = XML::Parser.new
    parser.string = xml_string
    document = parser.parse
    node = document.root
    result = AmazonSearchResult.new(node)
    result.asin.should == '0815411723'
    result.title.should == 'Josephine Baker: The Hungry Heart'
    result.formatted_price.should == '$21.95'
    result.author.should == 'Jean-Claude Baker'
    result.thumbnail_url.should == 'http://ecx.images-amazon.com/images/I/21FSPH7WW6L.jpg'
    result.affiliate_url.should == "http://www.amazon.com/dp/0815411723?tag=#{AMAZON_ASSOCIATE_ID}"
    result.binding.should == "Paperback"
    result.sales_rank.should == 389626
  end

  it "should sort by sales rank and imageless results come last" do
    with_image_ten = new_amazon_search_result
    with_image_ten.should_receive(:sales_rank).any_number_of_times.and_return(10)
    with_image_ten.should_receive(:thumbnail_url).any_number_of_times.and_return('http://anything.com/image.jpg')

    with_image_five = new_amazon_search_result
    with_image_five.should_receive(:sales_rank).any_number_of_times.and_return(5)
    with_image_five.should_receive(:thumbnail_url).any_number_of_times.and_return('http://anything.com/image.jpg')

    without_image_two = new_amazon_search_result
    without_image_two.should_receive(:sales_rank).any_number_of_times.and_return(2)
    without_image_two.should_receive(:thumbnail_url).any_number_of_times.and_return(nil)

    with_image_five.should be < with_image_ten
    with_image_ten.should be < without_image_two
  end

  private

  def new_amazon_search_result
    fake_node = Object.new
    fake_node.should_receive(:find_first).any_number_of_times.and_return(nil)
    AmazonSearchResult.new(fake_node)
  end

end