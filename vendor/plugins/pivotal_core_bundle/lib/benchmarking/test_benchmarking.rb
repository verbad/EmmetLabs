require "#{File.dirname(__FILE__)}/benchmarking_helper"
include Pivotal::Benchmarking

class Pivotal::RailsTestCase  
  cattr_reader :benchmark_stats
  
  def run(*args, &progress)
    seconds = Benchmark.realtime { super(*args, &progress) }
    @@benchmark_stats ||= []
    @@benchmark_stats << Stat.new(seconds, self.class.to_s, @method_name)
  end
end

at_exit do
  unless $! || Test::Unit.run?
    # TODO: this duplicates logic in at_exit_callback.  We should really make sure the bug is fixed in ruby
    begin
      exit_code = Test::Unit::AutoRunner.run
    rescue => e
      $stderr.puts e.message
      $stderr.puts e.backtrace
      exit_code = 1
    end
    print_benchmarking_report(Pivotal::RailsTestCase.benchmark_stats)
    exit exit_code
  end
end