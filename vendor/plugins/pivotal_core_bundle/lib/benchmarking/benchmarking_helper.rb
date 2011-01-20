module Pivotal
  module Benchmarking
    
    BENCHMARK_LIMIT = 0.01
    
    class Stat < Struct.new(:time, :context_name, :specification_name)
      def <=>(other)
        self.time <=> other.time
      end

      def to_s
        format("%7.3f sec\t%s %s", time, context_name, specification_name)
      end
    end
    
    def print_benchmarking_report(benchmark_stats)
      puts "\nBenchmarks for tests exceeding #{BENCHMARK_LIMIT} seconds"
      puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
      
      stats_to_print = benchmark_stats.find_all{|b| b.time > BENCHMARK_LIMIT}.sort.reverse
      truncated_stats = stats_to_print.collect do |stat|
        stat_string = stat.to_s
        if stat_string.length > 110
          "#{stat_string[0..110]}..." 
        else
          stat_string
        end
      end
      puts truncated_stats.join("\n")
    end
  end
end
    