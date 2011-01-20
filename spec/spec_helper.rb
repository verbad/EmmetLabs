# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'


dir = File.dirname(__FILE__)
require 'rubygems'
require File.expand_path(dir + "/../vendor/plugins/pivotal_core_bundle/lib/spec_framework_bootstrap")
require File.expand_path(dir + "/../vendor/plugins/user/test/test_case_methods")
include UserPluginTestCaseMethods

unless Object.const_defined?(:SPECS_INITIALIZED)
  describe 'login', :shared => true do
    before do
      @janice = users(:janice)
      log_in @janice
    end
  end
  DUCKLING_PHOTO_ID = '570101824'
  SPECS_INITIALIZED = true
end

class ActiveRecord::Base
  def self.find_last_created
    find(:first, :order => "id DESC")
  end
end

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Example::Configuration and Spec::Runner

  include FixtureHelper
  config.global_fixtures = *all_fixture_symbols
end

module Spec
  module Rails
    module DSL
      module ControllerInstanceMethods
        def integrate_views?
          return true
        end
      end
    end
  end
end