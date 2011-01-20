class Asset < ActiveRecord::Base
  CUSTOM_FILE_TYPES = YAML.load(File.new(File.join(File.dirname(__FILE__), *%w[.. .. config extensions.yml]))) unless const_defined?(:CUSTOM_FILE_TYPES)

  def photo?
     false
   end

  def self.extensions
    CUSTOM_FILE_TYPES.inject({}) do |extensions_by_type, (key, value)|
      (extensions_by_type[value] ||= []) << key
      extensions_by_type
    end[name]
  end
  
  protected

  def self.class_by_extension(extension)
    (CUSTOM_FILE_TYPES[extension]).constantize rescue UnknownAsset
  end
end