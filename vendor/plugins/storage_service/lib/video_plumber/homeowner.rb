require 'rubygems'
require 'active_resource'

class Homeowner
  def initialize(asset_version_id)
    @asset_version = VideoPlumber::AssetVersion.find(asset_version_id)
  end

  def progress_report(percentage)
    @asset_version.percent_completed = percentage
    @asset_version.state_name = "encoding"
    @asset_version.save
  end
end

module VideoPlumber
  class AssetVersion < ::ActiveResource::Base
    self.site = 'http://marketseven-demo.pivotallabs.com'
  end
end


