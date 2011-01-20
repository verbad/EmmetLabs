module Test
  module Unit
    class TestCase
      def run(result)
        yield(STARTED, name)
        @_result = result
        begin
          setup
          __send__(@method_name)
        rescue AssertionFailedError => e
          add_failure(e.message, e.backtrace)
        rescue Exception
          add_error($!)
        ensure
          begin
            teardown
          rescue AssertionFailedError => e
            add_failure(e.message, e.backtrace)
          rescue Exception
            add_error($!)
          end
        end
        result.add_run
        yield(FINISHED, name)
      end
    end
  end
end
