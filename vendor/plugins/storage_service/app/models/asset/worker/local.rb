class Asset::Worker::Local < Asset::Worker::Base
  def do(command, asset, version_name)
    command.start(asset, version_name)
    command.finish
  end
end