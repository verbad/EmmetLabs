ENV["RAILS_ENV"] ||= "test"

dir = File.dirname(__FILE__)
embedding_rails_root = "#{dir}/../../../.."

require File.expand_path(embedding_rails_root + "/config/environment")

require 'hpricot'
gem 'flexmock', '>= 0.6.0'
require 'flexmock'
require 'test/unit/ui/console/testrunner'
require "test_help"
require_package_based_on(dir + "/../lib/testunit_extensions")

require "seleniumrc_fu/selenium_test_case"

require 'pivotal_rails_test/quick_feedback_runner'
require 'pivotal_rails_test/common_test_helper'
require 'pivotal_rails_test/fixture_helper'
require 'pivotal_rails_test/mock_flash_hash'
require 'pivotal_rails_test/rails_test_case_fixtures_fix'
require 'pivotal_rails_test/isolated_plugin_test_case'
require 'pivotal_rails_test/rails_test_case'
require 'pivotal_rails_test/spy'
require 'pivotal_rails_test/benchmark_test_case'
require 'file_sandbox/file_sandbox'
require 'file_sandbox/file_sandbox_behavior'

require 'suites/suite_helper'
