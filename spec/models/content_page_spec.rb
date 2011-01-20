require File.dirname(__FILE__) + '/../spec_helper'

describe ContentPage do
  before(:each) do
    @content_page = ContentPage.new(:name => 'a new content page')
  end

  it "should be valid" do
    @content_page.should be_valid
  end

  it "should have a calculated dashified name based on name" do
    guidelines = content_pages(:guidelines)
    guidelines.calculated_dashified_name.should ==guidelines.name.dashify
    guidelines.name = 'a new dashified name'
    guidelines.save!
    guidelines.calculated_dashified_name.should ==guidelines.name.dashify    
  end
end
