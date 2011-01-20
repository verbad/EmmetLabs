class FakeStorageService < StorageServiceBase
  attr_accessor :files

  def initialize
    @files = {}
  end

  def url(locator, options)
    locator.path
  end

  def remove(locator)
    @files[locator] = nil
  end

  def store(locator, data)
    @files[locator] = data
  end

  def find(locator)
    @files[locator]
  end

  def exists?(locator)
    return !@files[locator].nil?
  end

  def relative_path(locator)
    locator.name
  end
end
