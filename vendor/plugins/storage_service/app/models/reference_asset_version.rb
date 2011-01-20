class ReferenceAssetVersion < AssetVersion
  def completed?
    referee.completed?
  end

  def pending?
    referee.pending?
  end

  def url(options = {})
    referee.url(options)
  end

  def data=(data)
  end

  protected

  def referee
    asset.versions[asset.class.versions[version.to_sym].real_version_name]
  end
end