class Asset::Command::Conversion::PdfToSwf < Asset::Command::Conversion::Base
  def extension
    'swf'
  end

  def process(source, destination)
    exec("/usr/bin/pdf2swf -o #{destination} #{source}")
  end
  
  def fast?
    false
  end
end