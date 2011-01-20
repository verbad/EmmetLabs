class S3StorageService < StorageServiceBase

  def proxy_url(url_string)
    uri = URI.parse(url_string)
    uri.scheme.nil? ? url_string : "/proxy/?#{url_string}"
  end

end