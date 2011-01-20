class Asset::Command::Conversion::Mp3Resampling < Asset::Command::Conversion::Base
  attr_accessor :width, :height
  
  def extension
    'mp3'
  end

  def initialize(width, height)
    self.width = width; self.height = height
  end  

  def process(source, destination)
    #  44.1 khz sample rate, 64 kbps bit rate
    #  This gets rid of the chipmunk effect with the Flash audio player
    #  (when the sample rate is not a multiple of 11.025 khz)
    #  See:  http://www.boutell.com/newfaq/creating/chipmunk.html
    exec("/usr/bin/lame --resample 44.1 -b 64 #{source} #{destination}")
  end

  def fast?
    false
  end
end