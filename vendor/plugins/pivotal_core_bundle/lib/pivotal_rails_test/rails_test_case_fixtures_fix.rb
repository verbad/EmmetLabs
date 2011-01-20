module Test
  module Unit
    class TestCase
      unless method_defined?(:setup_without_fixtures)
        def setup
        end
      end

      unless method_defined?(:teardown_without_fixtures)
        def teardown
        end
      end
    end
  end
end
