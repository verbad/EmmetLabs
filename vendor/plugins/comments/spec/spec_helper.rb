# These lines must be at the top of each plugin's test_helper
ENV["RAILS_ENV"] ||= "test"
dir = File.dirname(__FILE__)
require "#{dir}/../../pivotal_core_bundle/lib/spec_framework_bootstrap"
require File.expand_path(dir + "/../../user/test/test_case_methods")

Test::Unit::TestCase.fixture_path =  "#{dir}/../spec/fixtures"

class CommentableShim < ActiveRecord::Base
  include CanBeReviewed
  include CanBeCommentedOn
end

# Even if you're using RSpec, RSpec on Rails is reusing some of the
# Rails-specific extensions for fixtures and stubbed requests, response
# and other things (via RSpec's inherit mechanism). These extensions are 
# tightly coupled to Test::Unit in Rails, which is why you're seeing it here.
Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  dir = File.dirname(__FILE__)
  config.fixture_path = "#{dir}/../spec/fixtures"
  include UserPluginTestCaseMethods

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
end