at_exit do
  unless $! || Test::Unit.run?
    begin
      exit Test::Unit::AutoRunner.run
    rescue => e
      $stderr.puts e.message
      $stderr.puts e.backtrace
      exit 1
    end
  end
end
