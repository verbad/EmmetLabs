require 'rubygems'
require 'test/unit'
dir = File.dirname(__FILE__)
require "#{dir}/../lib/test_framework_bootstrap"
require 'pivotal_rails_test/common_test_helper'
require 'pivotal_rails_test/isolated_plugin_test_case'
require 'pivotal_rails_test/benchmark_test_case'
require 'pivotal_rails_test/spy'
require "pivotal_core_bundle"
require "flexmock"
