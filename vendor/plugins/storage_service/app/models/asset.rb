require 'open-uri'
class AssociationShim < ActiveRecord::Base
end

class Asset < ActiveRecord::Base
  validates_presence_of :data, :on => :create, :if => lambda {|asset| !asset.external?}
  validates_each :format  do |record, key, value|
    if record.data_is_dirty && !(record.class == Asset) && !(record.is_a? class_by_extension(get_extension(record.original_filename)))
      record.errors.add(:format, "Please upload a #{self}")
    end
  end

  acts_as_list :scope => :creator_id

  has_many :assets_associations, :dependent => :destroy, :class_name => 'AssetsAssociation'

  belongs_to :creator, :foreign_key => :creator_id, :class_name => "User"
  has_many :versions, :class_name => 'AssetVersion', :include => [:asset], :dependent => :destroy do
    def have_version?(version_name)
      self.any?{ |v| v.version == version_name.to_s }
    end

    def [](version_name)
      if have_version?(version_name)
        self.detect{ |v| v.version == version_name.to_s }
      else
        # i am lazy generation
        command = proxy_owner.class.versions[version_name]
        raise "Can't find command for version :#{version_name} in #{proxy_owner.class}" unless command
        raise Asset::OriginalDataIsMissingError unless proxy_owner.data
        ASSET_WORKER.do(command, proxy_owner, version_name)
        self.find_by_version(version_name.to_s)
      end
    end
  end

  after_destroy :remove_asset
  after_save :store_asset

  attr_accessor :data_is_dirty
  
  FILE_TYPES = YAML.load(File.new(File.join(File.dirname(__FILE__), *%w[.. .. config extensions.yml]))) unless const_defined?(:FILE_TYPES)

  def self.extensions
    FILE_TYPES.inject({}) do |extensions_by_type, (key, value)|
      (extensions_by_type[value] ||= []) << key
      extensions_by_type
    end[name]
  end

  def self.has_versions(versions)
    raise "you can't use a key called original because otherwise bad things will happen" if versions.key?(:original)
    @versions = versions
  end
  
  def format
    self.class
  end

  def self.versions
    @versions || {}
  end

  def self.has_version?(version)
    versions.keys.include?(version)
  end

  def original_filename
    self[:original_filename].blank? && !source_uri.nil? ? source_uri.split('/').last : self[:original_filename]
  end
  
  def initialize(*args, &block)
    super
    self.original_filename ||= self.class.asset_filename(args.first || {})
  end

  #TODO: WARNING and I mean SORRY. This will not scale, but better than has_many_polymorphs insanity.
  def associates
    assets_associations.map(&:associate)
  end

  def has_version?(version)
    versions.reset
    versions.have_version?(version)
  end

  def url(version = :original)
    self.versions[version].url
  end

  def data
    @data || self.versions[:original].data
  rescue
    nil
  end

  def data=(value)
    return if value.blank?
    @data_is_dirty = true
    if value.kind_of?(String)
      @data = open(value)
      self.source_uri = value
    else
      @data = value.to_tempfile
    end
  end

  def external?
    !self.source_uri.nil?
  end

  def self.new_by_file(params={}, asset_class=nil)
    new_from_upload(params, nil, asset_class || class_by_filename(asset_filename(params)))
  end

  def self.asset_filename(params)
    params[:original_filename] || (params[:data] && params[:data].original_filename) rescue ''
  end

  def self.new_from_upload(params, upload=nil, asset_class=self)
    params[:data] = upload if upload
    asset = asset_class.new(params)
    asset.original_filename = asset_filename(params)
    return asset
  end

  def read
    data.rewind
    data.read
  end

  def to_s
    original_filename
  end

  protected
  def self.class_by_extension(extension)
    return (FILE_TYPES[extension]).constantize rescue UnknownAsset
  end
  
  def self.class_by_filename(filename)
    class_by_extension(get_extension(filename))
  end

  def self.get_extension(filename)
    filename.match(/\.([^.]+)$/)[1].downcase rescue :undefined
  end

  def remove_asset
    self.versions.each do |version|
      version.destroy
    end
  end

  def store_asset
    return true unless @data_is_dirty
    @data_is_dirty = false
    ASSET_WORKER.do(Asset::Command::Identity.new, self, :original)
    self.class.versions.each do |version_name, command|
      ASSET_WORKER.do(command, self, version_name)
    end
  end

  class OriginalDataIsMissingError < StandardError
  end
end