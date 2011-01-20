dir = File.dirname(__FILE__)
$LOAD_PATH.unshift File.join(dir,'..','lib','video_plumber')

# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= "test"

require File.expand_path(dir + "/../../../../vendor/plugins/pivotal_core_bundle/lib/spec_framework_bootstrap")

require "#{RAILS_ROOT}/vendor/plugins/user/test/test_case_methods"

require 'hpricot'
require 'active_resource/http_mock'

Test::Unit::TestCase.fixture_path =  RAILS_ROOT + '/test/fixtures'

# Even if you're using RSpec, RSpec on Rails is reusing some of the
# Rails-specific extensions for fixtures and stubbed requests, response
# and other things (via RSpec's inherit mechanism). These extensions are 
# tightly coupled to Test::Unit in Rails, which is why you're seeing it here.
Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/test/fixtures'
end

def eval_context_eval(&block)
  Spec::Rails::Runner::EvalContext.class_eval(&block)
end