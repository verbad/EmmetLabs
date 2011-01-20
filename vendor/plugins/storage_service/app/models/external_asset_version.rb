require 'open-uri'

class ExternalAssetVersion < AssetVersion
  def completed?
    true
  end

  def pending?
    false
  end

  def url(options = {})
    uri
  end

  def data
    open(uri)
  end
end