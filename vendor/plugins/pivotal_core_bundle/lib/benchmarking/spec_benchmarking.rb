require "#{File.dirname(__FILE__)}/benchmarking_helper"
include Pivotal::Benchmarking

module Spec
  module Runner
    class ContextRunner
      cattr_accessor :benchmark_stats
    end
    
    class Specification      
      def run_with_benchmarking(reporter, *rest_of_args)
        seconds = Benchmark.realtime { run_without_benchmarking(reporter, *rest_of_args) }
        ContextRunner.benchmark_stats ||= []
        ContextRunner.benchmark_stats << Stat.new(seconds, reporter.last_context_name, name)
      end
      alias_method_chain :run, :benchmarking
    end
    
    class Reporter      
      def dump_with_benchmarking
        return_code = dump_without_benchmarking
        print_benchmarking_report(ContextRunner.benchmark_stats)
        return return_code
      end
      alias_method_chain :dump, :benchmarking
      
      def last_context_name
        @context_names.last
      end
    end
  end
end