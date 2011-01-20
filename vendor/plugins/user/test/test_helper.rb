# These lines must be at the top of each plugin's test_helper
dir = File.dirname(__FILE__)
require "#{dir}/../../pivotal_core_bundle/lib/test_framework_bootstrap"
Test::Unit::TestCase.fixture_path =  File.expand_path(dir + "/fixtures/")

require "#{dir}/test_case_methods"

# Plugin-specific test helper code below
class ApplicationController
  public :current_user, :current_user=, :logged_in?
end

require 'users_controller'

class UserPluginTestCase < Pivotal::FrameworkPluginTestCase
  include FlexMock::TestCase
  include UserPluginTestCaseMethods
  
  fixtures :users,
           :tokens,
           :profiles,
           :profile_answers,
           :profile_questions,
           :profile_question_categories,
           :assets, 
           :assets_associations,
           :terms_of_services,
           :asset_versions,
           :email_addresses
end