require 'aws/s3'

class S3StorageService < StorageServiceBase
  attr_accessor :access_key, :secret_key, :repository, :options

  def initialize(repository, pub, priv, options = {})
    repository || raise(ArgumentError.new("must define a repository for this connection"))
    @access_key = pub
    @secret_key = priv
    @repository = repository
    @options = options
    create_repository_if_necessary
  end

  def store(locator, data)
    name = relative_path(locator)
    check_connection
    AWS::S3::S3Object.store(name,
      data,
      self.repository,
      {:access => :public_read}
    )
  ensure
    disconnect!
    data.rewind
  end

  def find(locator)
    name = relative_path(locator)
    check_connection
    file = AWS::S3::S3Object.find(name, @repository).value
  end

  def exists?(locator)
    name = relative_path(locator)
    check_connection
    AWS::S3::S3Object.exists?(name, @repository)
  end

  def url(locator, options = {})
    if options[:expires_in]
      check_connection
      return AWS::S3::S3Object.url_for(relative_path(locator), @repository, options)
    else
      location + "/" + relative_path(locator)
    end
  end

protected

  def remove(locator)
    name = relative_path(locator)
    check_connection
    file = AWS::S3::S3Object.delete(name, @repository)
  end

  def location
    if (@options[:ssl])
      return "https://s3.amazonaws.com/#{@repository}"
    else
      return (@options[:use_as_domain]) ? "http://#{@repository}" : "http://s3.amazonaws.com/#{@repository}"
    end
  end

  def self.read_access_key(file)
    read_line(file)
  end

  def self.read_secret_key(file)
    read_line(file)
  end

  def self.read_line(filename)
    key = nil
    begin
      file = File.open(filename)
      key = file.gets
    ensure
      file.close if (file && !file.closed?)
     end
    key
  end

  def create_repository_if_necessary
    check_connection
    begin
      AWS::S3::Bucket.find(@repository)
    rescue AWS::S3::NoSuchBucket => e
      AWS::S3::Bucket.create(@repository)
    end
  end


  def connected?
    AWS::S3::Base.connected?
  end

  def connect()
    keys = {
      :access_key_id     => self.access_key,
      :secret_access_key => self.secret_key,
      :persistent => false
    }
    AWS::S3::Base.establish_connection!(keys)
  end

  def disconnect!
    AWS::S3::Base.disconnect!
  end

  def check_connection
    connect unless connected?
  end

end