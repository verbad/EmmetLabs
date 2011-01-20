#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', '..', '..', '..', '..', 'init')
require File.join(File.dirname(__FILE__), 'progress_parser')
require File.join(File.dirname(__FILE__), 'butler')
require File.join(File.dirname(__FILE__), 'homeowner')

if __FILE__ == $0
  asset_version_id = ARGV.shift
  ProgressParser.new(Butler.new(Homeowner.new(asset_version_id))) \
    .parse(STDIN)
end