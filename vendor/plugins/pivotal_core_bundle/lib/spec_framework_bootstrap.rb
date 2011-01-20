dir = File.dirname(__FILE__)
require File.expand_path(dir + "/slow_test_debug")

ENV["RAILS_ENV"] ||= "test"

embedding_rails_root = "#{dir}/../../../.."

require "rubygems"

SlowTestDebug.time("require config/environment") {require File.expand_path(embedding_rails_root + "/config/environment")}

SlowTestDebug.time('other requires in spec_framework_bootstrap') do
require "spec"

require 'application'
require 'spec/rails'
require 'hpricot'

require_package_based_on(dir + "/../lib/rspec_extensions")
require "pivotal_rails_test/mock_flash_hash"
require "pivotal_rails_test/common_test_helper"
require 'pivotal_rails_test/fixture_helper'
require 'rspec_extensions/action_controller_rescue'
require 'rspec_extensions/disabled_specs'
require 'rspec_extensions/fixtures_collection'
require 'rspec_extensions/spec_helper'
require 'rspec_extensions/spec_helper_matchers'
require 'suites/suite_helper'
require 'rspec_extensions/spec_suite_helper'
require 'rspec_extensions/config_include_post_1_0_hack.rb'
require 'file_sandbox/file_sandbox'
end

module Spec::Runner
  class << self
    include FixtureHelper
    def fixture_path
      configuration.fixture_path
    end

    def configure(&blk)
      # Apparently not needed, and breaks Rspec > 1.0.8
      # return unless @configuration.nil?
      yield configuration

      configuration.global_fixtures = all_fixture_symbols
      configuration.include SpecHelper
      configuration.include CommonTestHelper
      configuration.include(SpecHelperMatchers)
      configuration.use_transactional_fixtures = true
      configuration.use_instantiated_fixtures  = false
    end
  end
end

SlowTestDebug.print_report
