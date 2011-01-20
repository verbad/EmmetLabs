ENV["RAILS_ENV"] ||= "test"

require 'hpricot'
require 'flexmock'
require 'test/unit/ui/console/testrunner'
require "test_help"
require_package_based_on(dir + "/../lib/testunit_extensions")

require 'pivotal_rails_test/quick_feedback_runner'
require 'pivotal_rails_test/common_test_helper'
require 'pivotal_rails_test/fixture_helper'
require 'pivotal_rails_test/rails_test_case_fixtures_fix'
require 'pivotal_rails_test/isolated_plugin_test_case'
require 'pivotal_rails_test/rails_test_case'
require 'pivotal_rails_test/spy'
require 'pivotal_rails_test/benchmark_test_case'
