class Asset::Worker::Fake < Asset::Worker::Base
  def do(command, asset, version_name)
    command.start(asset, version_name)
    version = asset.reload.versions[version_name]
    version.state = AssetVersion::State[:completed]
    version.save!
  end
end