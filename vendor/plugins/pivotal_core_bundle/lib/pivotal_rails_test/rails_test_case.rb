module Pivotal

  module FixtureLoaderHelper
    def setup_with_fixtures(*args)
      super(*args)
    end

    def teardown_with_fixtures(*args)
      super(*args)
    end

    def load_fixtures_with_pivotal_fk_constraint_disabling
      ActiveRecord::Base.connection.update('SET FOREIGN_KEY_CHECKS = 0')
      load_fixtures_without_pivotal_fk_constraint_disabling
      ActiveRecord::Base.connection.update('SET FOREIGN_KEY_CHECKS = 1')
    end

    def self.included(klass)
      klass.alias_method_chain :load_fixtures, :pivotal_fk_constraint_disabling
    end

  end

  class SeleniumTestCase < SeleniumrcFu::SeleniumTestCase
    extend FixtureHelper
    include CommonTestHelper
  end
  
  class RailsTestCase < Test::Unit::TestCase
    extend FixtureHelper
    include CommonTestHelper
    include FixtureLoaderHelper
    include FlexMock::TestCase

    @@validated_fixtures = false

    def setup
      super
      Clock.now = Time.now if Clock.respond_to? :now=
      set_mock_flash
      ActionMailer::Base.deliveries.clear
    end

    def teardown
      super
    end

    def set_mock_flash
      flash = MockFlashHash.new
      flexstub(ActionController::Flash::FlashHash).should_receive(:new).and_return(flash)
    end

    def validate_fixtures()
      return if @@validated_fixtures
      @@validated_fixtures = true

      fixture_symbols = self.all_fixture_symbols
      class_names = fixture_symbols.collect {|fixture_symbol| fixture_symbol.to_s.singularize.camelize}
      classes = class_names.collect do |class_name|
        begin
          Object.const_get(class_name)
        rescue NameError => e
          RAILS_DEFAULT_LOGGER.error("Cannot validate fixture because #{e}")
          nil
        end
      end
      classes.each do |klass|
        validate_fixtures_for(klass)
      end
    end

    self.use_transactional_fixtures = true
    self.use_instantiated_fixtures  = false

    fixtures *self.all_fixture_symbols

    def validate_fixtures_for(klass)
      if klass
        all_fixtures_for_class = klass.find(:all)
        for phixture in all_fixtures_for_class
          assert phixture.valid?, "Fixture #{phixture.inspect} should be valid!"
        end
      end
    end
  end

  class RailsIntegrationTestCase < ActionController::IntegrationTest
    extend FixtureHelper
    include CommonTestHelper
    include FixtureLoaderHelper

    def setup
      super
    end
    def teardown
      super
    end

    self.use_transactional_fixtures = true
    self.use_instantiated_fixtures  = false

    fixtures *self.all_fixture_symbols

    alias xhr xml_http_request
  end

  class FrameworkPluginTestCase < Test::Unit::TestCase
    extend FixtureHelper
    include CommonTestHelper
    include FixtureLoaderHelper
    include FlexMock::TestCase

    def setup
      super
    end

    def teardown
      super
    end

    self.use_transactional_fixtures = true
    self.use_instantiated_fixtures  = false
  end

end
