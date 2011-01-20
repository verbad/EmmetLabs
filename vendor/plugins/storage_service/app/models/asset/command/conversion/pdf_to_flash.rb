class Asset::Command::Conversion::PdfToFlash < Asset::Command::Base
  attr_accessor :width, :height
  def extension
    'swf'
  end

  def initialize(width, height)
    self.width = width; self.height = height
  end

  def size
    AssetVersion::Size.new(width, height)
  end

  def do(data)
    Asset::Command::Conversion::SwfCombiner.new.do(Asset::Command::Conversion::PdfToSwf.new.do(data))
  end

  def fast?
    false
  end
end