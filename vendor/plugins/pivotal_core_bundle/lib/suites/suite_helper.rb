module Suites
  module SuiteHelper
      def slow_suite?
        return false if ENV['SLOW_SUITE'] == 'false'
        return true if ENV['SLOW_SUITE']
      end

      def external_suite?
        return false if ENV['EXTERNAL_SUITE'] == 'false'
        return true if ENV['EXTERNAL_SUITE']
      end
  end
end

module Test
  module Unit
    class TestCase
      include Suites::SuiteHelper
    end
  end
end