class Asset::Command::Conversion::SwfCombiner < Asset::Command::Conversion::Base
  def extension
    'swf'
  end

  def process(source, destination)
    exec("/usr/bin/swfcombine /opt/scripts/viewer.swf '#'1=\"#{source}\" -o #{destination}")
  end
  
  def fast?
    false
  end
end