class Asset::Command::FakeResized < Asset::Command::Base
  attr_accessor :real_version_name, :width, :height

  def initialize(real_version_name, width, height)
    self.real_version_name, self.width, self.height = real_version_name, width, height
  end

  def do(data)
    data
  end

  def version_class
    ReferenceAssetVersion
  end

  def size
    AssetVersion::Size.new(width, height)
  end
end