require 'test/unit'
dir = File.dirname(__FILE__)
require "#{dir}/../../../lib/testunit_extensions/at_exit_callback"

class Test::Unit::AutoRunner
  def run
    raise "Foobar"
  end
end
