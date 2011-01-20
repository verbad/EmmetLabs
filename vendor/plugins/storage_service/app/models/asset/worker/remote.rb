class Asset::Worker::Remote < Asset::Worker::Base
  attr_accessor :queue

  def initialize(queue = SqsQueue.new(RAILS_ENV))
    self.queue = queue
  end

  def do(command, asset, version_name)
    command.start(asset, version_name)
    unless command.fast?
      queue.push command
    else
      command.finish
    end
  end
end