dir = File.dirname(__FILE__)
Dir["#{dir}/../../*"].each do |plugin_dir|
  path = File.expand_path("#{plugin_dir}/lib")
  $LOAD_PATH << path unless $LOAD_PATH.include?(path)
end

require "tmpdir"
require "bootstrap/require_package_based_on"
require "spec/rake/spectask"
require "bootstrap/rake_task_manager"
require "command_line"