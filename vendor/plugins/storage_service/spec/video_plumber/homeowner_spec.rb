require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Homeowner do
  before do
    @asset_version_1_info  = {
      :status => "Encoding",
      :id => 1
    }.to_xml(:root => 'asset_version')
  end

  it "should communicate over HTTP pipe a percent of 12" do
    ::ActiveResource::HttpMock.respond_to do |mock|
      mock.get    "/asset_versions/1.xml",             {}, @asset_version_1_info, 200
      mock.put    "/asset_versions/1.xml",             {}, nil, 200
    end
    homeowner = Homeowner.new(1)
    proc { homeowner.progress_report(0.12) }.should_not raise_error
    
  end

  it "should error with invalid asset id" do
    ::ActiveResource::HttpMock.respond_to do |mock|
       mock.get    "/asset_versions/pickle.xml",        {}, nil, 404
    end
    proc { Homeowner.new('pickle') }.should raise_error
  end
end