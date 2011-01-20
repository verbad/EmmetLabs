class StorageServiceBase

  def put(locator, data)
    store(locator.normalize, data)
  end

  def get(locator)
    return nil unless exists?(locator.normalize)
    data = find(locator.normalize)
    return io_ize(data)
  end

  def delete(locator)
    return unless exists?(locator)
    remove(locator)
  end

  def url_for(locator, options = {})
    url(locator.normalize, options)
  end

  def exists?(locator)
    raise_implement_this
  end

  protected
  def relative_path(locator)
    File.join(%W{#{locator.id} #{locator.path}})
  end

  def find(asset)
    raise_implement_this
  end

  def store(asset, data)
    raise_implement_this
  end

  def remove(asset)
    raise_implement_this
  end

  def io_ize(data)
    case data
    when String
      return StringIO.new(data)
    else
      return data
    end
  end

  def raise_implement_this
    file_and_method_name = Kernel.caller[0]
    method_name = file_and_method_name[file_and_method_name.index("`")..file_and_method_name.index("'")]
    raise NotImplementedError.new("You must implement #{method_name} in the #{self.class} class")
  end
  
end