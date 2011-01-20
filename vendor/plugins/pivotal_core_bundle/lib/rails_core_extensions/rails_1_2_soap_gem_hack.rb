if Rails::VERSION::MAJOR == 1 and Rails::VERSION::MINOR == 2
  begin
    gem 'soap4r', '1.5.8'
  rescue Exception => e
    # HACK: soap4r could not be required, so it must not be installed, so it should not break rails 1.2.x"
  end
end
