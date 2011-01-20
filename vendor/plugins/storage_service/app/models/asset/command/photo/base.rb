require 'RMagick'

class Asset::Command::Photo::Base < Asset::Command::Base
  attr_accessor :width, :height, :options

  def initialize(width, height, options = {})
    self.width = width
    self.height = height
    self.options = options.reverse_merge(
      :quality => 50
    )
  end

  def do(data)
    raise "cannot pass nil to Photo::Base" if data.nil?
    image = process(Magick::Image.from_blob(data.read).first)
    image.strip!
    quality = options[:quality]
    StringIO.new(image.to_blob {
      self.quality = quality
    })
  end

  def self.orientation(image)
    return :landscape if image.rows < image.columns
    return :portrait if image.rows > image.columns
    return :square
  end

  def extension
    nil
  end

  def size
    AssetVersion::Size.new(width, height)
  end

  protected
  def process(image)
    raise "override me"
  end
end
