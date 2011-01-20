require 'mime/types'

class Asset::Command::Base
  attr_accessor :version
  
  def self.*(command_class)
    receiver_of_composition_message = self

    Class.new(Asset::Command::Base) do
      define_method :extension do
        command_class.new.extension
      end

      define_method(:do) do |original_data|
        result = command_class.new.do(intermediate = receiver_of_composition_message.new.do(original_data))
        File.unlink(intermediate.path) if result.path != intermediate.path
        result
      end
    end
  end
  
  def fast?
    true
  end

  def version_class
    InternalAssetVersion
  end

  def extension
    nil
  end

  def mime_type
    MIME::Types.of(extension).first.content_type rescue nil
  end

  def destination_filename(original_filename)
    original_filename + (extension ? '.' + extension : '')
  end

  def do(data)
    raise "override me"
  end

  def create_temporary_file(data, filename)
    destination = '/tmp/'+filename
    File.open(destination, "w") do |f|
      f.write data
    end
    destination
  end

  def to_yaml_properties
    super + ['@version']
  end
  
  def start(asset, version_name)
    mime_type = self.mime_type || MIME::Types.of(asset.original_filename).first.content_type rescue nil
    self.version = version_class.create(
      :filename => destination_filename(asset.original_filename),
      :uri => asset.source_uri,
      :version => version_name.to_s,
      :state => AssetVersion::State[:pending],
      :mime_type => mime_type,
      :asset => asset
    )
  end
  
  def finish
    version.data = self.do(version.asset.data)
    version.asset.data.rewind
    version.state = AssetVersion::State[:completed]
    version.save!
  end
end