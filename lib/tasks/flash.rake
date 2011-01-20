namespace :flash do
  desc "Compiles the flash files into public/flash"
  task :compile => [:network, :wander, :timeline] 
  
  # TODO: These are begging to be made into a rule
  task :network do
    FlashApp.new("NetworkApp").compile
  end
  
  task :wander do
    FlashApp.new("WanderApp").compile
  end
  
  task :timeline do
    FlashApp.new("TimelineApp").compile
  end
end

class FlashApp
  def initialize(name)
    @name = name
  end

  def compile
    dir = RAILS_ROOT + "/app/flash/NetworkApp" #TODO: yes, this should change
    file = "#{dir}/#{@name}.as"
    outputfile = "#{RAILS_ROOT}/public/flash/#{@name}.swf"
    # TODO: Handle errors?
    puts `#{RAILS_ROOT}/vendor/flex_sdk/bin/mxmlc #{file} -output #{outputfile}`
  end
end