class LocalDiskStorageService < StorageServiceBase
  attr_reader :url_prefix, :repository

  def initialize(filesystem_storage_root, url_prefix = "")
    filesystem_storage_root || raise(ArgumentError.new("must define a repository for this connection"))
    @repository = filesystem_storage_root
    FileUtils.makedirs(repository) if(!File.exists?(@repository))
    FileUtils.makedirs("#{@repository}/") if(!File.exists?("#{@repository}/"))
    @url_prefix = url_prefix
  end

  def url(locator, options = {})
    "#{@url_prefix}/#{relative_path(locator)}"
  end

  def exists?(locator)
    File.exists?(path_to(locator))
  end

  def find(locator)
    data = nil
    File.open(path_to(locator)) do |file|
      file.binmode
      data = file.read
    end
    return data
  end

protected

  def store(locator, data)
    begin
      FileUtils.makedirs(File.dirname(path_to(locator)))
      f = write_file(path_to(locator), data)
    rescue => e
      f.close if (f && f.open?)
      raise e
    ensure
      data.rewind
    end
  end

  def remove(locator)
    File.delete(path_to(locator))
  end

  def path_to(locator)
    "#{@repository}/#{relative_path(locator)}"
  end

  def write_file(filepath, data)
    File.open(filepath, 'wb+') do |file|
      if data.respond_to?(:read)
          while buf = data.read(102400) # by 100k
            file.write(buf)
          end
      else
        file.write(data)
      end
    end
  end

end