class Asset::Command::Photo::ResizedAndCropped < Asset::Command::Photo::Base
  attr_accessor :gravity

  def initialize(width, height, gravity = nil)
    super(width, height)
    self.gravity = gravity
  end

  def process(image)
    unless gravity
      self.gravity = case self.class.orientation(image)
                       when :portrait, :square
                         Magick::NorthGravity
                       when :landscape
                         Magick::CenterGravity
      end
    end
    image.crop_resized!(width, height, gravity)
  end
end