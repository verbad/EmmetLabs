module FixtureHelper
  module ModuleMethodsWhenLibraryIsBeingUsed
    def fixture_path
      Test::Unit::TestCase.fixture_path || RAILS_ROOT + "/test/fixtures"
    end

    def all_fixture_symbols
      symbols = []
      Dir["#{fixture_path}/*.yml"].each do |fixture_file|
        symbols << File.basename(fixture_file, ".yml").to_sym
      end
      symbols
    end

 end

  module ModuleMethodsWhenLibraryIsBeingTested
    # stub to test this
    def fixtures
    end

    def all_fixture_symbols
      []
    end

    attr_accessor :use_transactional_fixtures, :use_instantiated_fixtures
  end

  if Object.const_defined?(:RAILS_ROOT)
    extend ModuleMethodsWhenLibraryIsBeingUsed
    include ModuleMethodsWhenLibraryIsBeingUsed
  else
    extend ModuleMethodsWhenLibraryIsBeingTested
    include ModuleMethodsWhenLibraryIsBeingTested
  end

  module ModuleMethods
    def fixture_symbols
      raise "fixture_symbols is deprecated. Use all_fixture_symbols instead."
    end
  end
  extend ModuleMethods
  include ModuleMethods
end
