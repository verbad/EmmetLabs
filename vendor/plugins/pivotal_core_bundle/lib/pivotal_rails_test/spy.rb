class Spy

  def initialize(verbose = false)
    @methods_called = []
    @verbose = verbose
  end

  def method_missing(method_name, *args)
    method = [ method_name ] + args
    puts "missing method called: #{method.inspect}" if @verbose
    @methods_called << method
  end
  
  def was_called?(method_name, *args)
    (@methods_called.include? [ method_name ] + args) || (methods_called.include? method_name)
  end
  
  def was_called_exactly?(method_name, *args)
    (@methods_called.include? [ method_name ] + args)
  end
  
  # usage: mock.were_called?( [:method1, arg1, arg2], [:method2, arg1, arg2, arg3] )
  def were_called?(*args)
    return were_called_exactly? || (methods_called == args.collect{|x| x[0]})
  end
  
  def were_called_exactly?(*args)
    return @methods_called == args
  end
  
  def methods_called
    return @methods_called.collect{|x| x[0]}
  end

  def last_method_called_with_arguments
    return @methods_called.last
  end
  
  def assert_called(*args)
    if !were_called?(*args)
      raise "Expected #{args.inspect}\n" + 
            " but was #{@methods_called.inspect}"
    end
  end

  def assert_called_exactly(*args)
    if !were_called_exactly?(*args)
      raise "Expected #{args.inspect}\n" + 
            " but was #{@methods_called.inspect}"
    end
  end
end
