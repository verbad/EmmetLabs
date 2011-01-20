dir = File.dirname(__FILE__)
require "#{dir}/../../pivotal_core_bundle/lib/spec_framework_bootstrap"
require File.expand_path(dir + "/../../user/test/test_case_methods")
Test::Unit::TestCase.fixture_path =  "#{dir}/../test/fixtures"

Spec::Runner.configure do |config|
  dir = File.dirname(__FILE__)
  config.fixture_path = "#{dir}/../test/fixtures"
  config.before(:each) do
    ActionMailer::Base.deliveries = []
  end
  include UserPluginTestCaseMethods

  describe "TOS exists", :shared => true do
    before do
      @old_tos = TermsOfService.create!(:text => 'My Old TOS')
      @tos = TermsOfService.create!(:text => 'My TOS')
    end
  end
  
  config.prepend_before do
    class << ActionController::Flash::FlashHash
      def new
        MockFlashHash.new
      end
    end
  end
end