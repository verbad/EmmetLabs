class Asset::Command::ExternalReference < Asset::Command::Base
  attr_accessor :width, :height

  def initialize(width, height)
    self.width, self.height = width, height
  end

  def do(data)
    data
  end

  def version_class
    ExternalAssetVersion
  end

  def size
    AssetVersion::Size.new(width, height)
  end
end