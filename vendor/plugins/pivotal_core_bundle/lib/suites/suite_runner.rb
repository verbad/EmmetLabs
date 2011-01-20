module Suites
  class SuiteRunner
    attr_reader :fail_fast

    def initialize(fail_fast = true)
      @fail_fast = fail_fast
      @success = true
    end

    def success?
      @success
    end

    def run_cmd(cmd, suite_name)
      if !system(cmd)
        handle_suite_error suite_name
      end
    end

    def handle_suite_error(suite_name)
      if @fail_fast
        raise "#{suite_name} Suite FAILED"
      else
        @success = false
      end
    end

    def error_code?
      $?.exitstatus != 0
    end
  end  
end
