class Asset::Command::Conversion::VideoToFlash < Asset::Command::Conversion::Base
  attr_accessor :width, :height
  VIDEO_PLUMBER_PATH = File.join(File.dirname(__FILE__), '..', '..', '..', '..', '..', 'lib', 'video_plumber', 'video_plumber.rb')

  def initialize(width, height)
    self.width = width; self.height = height
  end

  def extension
    'flv'
  end

  def process(source, destination)
    # no bitrate.. encoder seems to make a decision about the bitrate
    
    # 2400 vbitrate => ~300meg takes ~360seconds

    # no frame rate specified for lavcopts defaults to current video frame rate (best)
    # lavcopts thread option is not supported by FLV encoding
    # setting vqmin=3 for flv (minium quantizer)
    # progress goes to stdout, have to re-bind
    #
    # -v stands for "VERY VERY IMPORTANT OR THE TIME Based Percent Strategy DON'T WORK"
    opts = %W(
      -v
      -of lavf
      -oac mp3lame
      -lameopts abr:br=64
      -srate 22050
      -ovc lavc
      -lavfopts i_certify_that_my_video_stream_does_not_use_b_frames -lavcopts vqmin=3:autoaspect:vcodec=flv:keyint=50:mbd=2:mv0:trell:v4mv:cbp:last_pred=3
      -xy #{width}
      -zoom
      -vf scale,dsize=4/3,expand=#{width}:#{height}
    ).join(' ')



    mencoder = "time /usr/bin/mencoder #{source} -o #{destination} #{opts} 2> /dev/null | ruby #{VIDEO_PLUMBER_PATH} #{version.id}"
    exec(mencoder)
    exec("/usr/bin/flvtool2 -UP #{destination} > /dev/null")
  end

  def size
    AssetVersion::Size.new(width, height)
  end
  
  def fast?
    false
  end
end