require File.dirname(__FILE__) + "/../lib/no_framework_bootstrap"

desc "Run all tests and specs in the app"
overridable_task :testspec do
  tasks = [:test]
  tasks << :spec if RakeTaskManager.task_defined?(:spec)

  RakeTaskManager.invoke_tasks_in_aggregation(*tasks)
end

namespace :testspec do
  RakeTaskManager.define_test_task_with_pattern("plugins", "vendor/plugins/#{ENV['PLUGIN'] || '**'}/**/*_test.rb")
  RakeTaskManager.define_spec_task_with_pattern("plugins", "vendor/plugins/#{ENV['PLUGIN'] || '**'}/**/*_spec.rb")
  Rake::Task['testspec:plugins'].comment = "Run the plugin tests and specs in vendor/plugins/** (or specify with PLUGIN=name)"

  desc "Test all plugins in config/plugins_to_test.yml"
  task :all_plugins do
    require "yaml"
    rake_plugins = YAML.load_file(RAILS_ROOT + "/config/plugins_to_test.yml")
    errored_plugins = []
    rake_plugins.each do |plugin|
      p "Testing plugin #{plugin}"
      cmd = "#{rake_command} testspec:plugins PLUGIN=#{plugin}"
      results = `#{cmd}`
      exit_status_successful = $?.success?
      puts results
      lines = results.split("\n")

      found_status_line = false
      tests, specs, assertions, failures, errors = 0
      lines.reverse.each do |line|
        if !exit_status_successful
          found_status_line = true
          failures = 0
          errors = 1
          break
        elsif matches = line.match(/(\d+) tests?, (\d+) assertions?, (\d+) failures?, (\d+) errors?/)
          found_status_line = true
          blah, tests, assertions, failures, errors = matches.to_a.collect {|match| match.to_i}
          break
        elsif matches = line.match(/(\d+) examples?, (\d+) failures?/)
          blah, specs, failures = matches.to_a.collect {|match| match.to_i}
          errors = 0
          found_status_line = true
          break
        end
      end
      raise "Could not find status line for plugin: #{plugin}" unless found_status_line
      errored_plugins << plugin if failures > 0 || errors > 0
    end
    unless errored_plugins.empty?
      error_message = "Test failures in the following plugins: #{errored_plugins.join(', ')}"
      # make SURE the error message gets printed...  even if it is printed more than once.
      STDERR.print("#{error_message}\n")
      STDOUT.print("#{error_message}\n")
      raise error_message
    end
  end
end

