class Asset::Command::Conversion::OfficeToPdf < Asset::Command::Conversion::Base
  def extension
    'pdf'
  end
  
  def process(source, destination)
    exec("/opt/openoffice.org2.2/program/python /opt/scripts/DocumentConverter.py  #{source} #{destination}")
  end
  
  def fast?
    false
  end
end