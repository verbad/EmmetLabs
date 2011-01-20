class InternalAssetVersion < AssetVersion
  def completed?
    state == AssetVersion::State[:completed]
  end

  def pending?
    state == AssetVersion::State[:pending]
  end

  def url(options = {})
    return STORAGE_SERVICE.url_for(locator, options)
  end

  def data=(data)
    @data_dirty = true
    @data = data
  end

  def locator
    Locator.new(asset_id, version.to_s + '/' + filename.to_s)
  end

  def to_yaml_properties
    [':locator', ':id'] + (original==self ? [] : [':original'])
  end

  def instance_variable_get(v)
    super(v) rescue self.send(v[1..-1].to_sym)
  end

  def data
    STORAGE_SERVICE.get(locator)
  end

  protected
  def after_save
    STORAGE_SERVICE.put(locator, @data) if @data_dirty
  end

  def after_destroy
    STORAGE_SERVICE.delete(locator)
  end
end