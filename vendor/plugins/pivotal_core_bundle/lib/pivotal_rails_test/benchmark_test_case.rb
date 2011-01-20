module BenchmarkTestCase
  module ModuleMethods
    def <<(msg)
      benchmarks << msg
    end

    private
    def benchmarks
      @benchmarks ||= []
    end
  end
  extend ModuleMethods

  def run(*args, &progress)
    sec = Benchmark.realtime do
      super(*args, &progress)
    end
    msg = format("%7.3f sec\t%s#%s", sec, self.class.to_s, @method_name)
#    BenchmarkTestCase << msg
    puts msg
  end

end
