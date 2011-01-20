class Locator < Struct.new(:id, :path)
  def normalize
    Locator.new(id, path.to_s.gsub(/[^A-Za-z0-9.\/]/, "_").downcase)
  end
end