require File.dirname(__FILE__) + "/../lib/no_framework_bootstrap"

############################
# Helper methods
############################

def windows?
  RUBY_PLATFORM =~ /mswin32/
end

def rake_command
  windows? ? "rake.bat" : "rake"
end

# =============================================================================
# Default tasks
# =============================================================================

# NOTE: This does NOT redefine :default, it appends...
task :default => :testspec

desc "Run the app in development mode. Pass extra Mongrel arguments with ARGS="
task :run do
  system "mongrel_rails start #{ENV['ARGS']}"
end

desc "Run all the tests, including Test::Unit, Spec, JSUnit and Selenium"
overridable_task :alltests do
  puts "\nRunning tests and specs"
  Rake::Task[:testspec].invoke

  puts "\nRunning jsunit tests"
  Rake::Task['jsunit:test'].invoke

  puts "\nRunning selenium tests"
  Rake::Task['selenium:test'].invoke
end

task :all => "alltests"
