
def overridable_task(arg, &block)
  task_name = arg.is_a?(Hash) ? arg.keys.first : arg
  if Rake::Task.task_defined? task_name
    common_task_name = "#{task_name}_for_common"
    if arg.is_a?(Hash)
      arg = {common_task_name => arg[task_name]}
    else
      arg = common_task_name
    end
  end
  task(arg, &block)

  if Rake::Task.task_defined? "#{task_name}_for_project"
    raise "Error: 'task :#{task_name}_for_project is deprecated; just use 'task :#{task_name}'"
  end
end

module Rake
  module TaskManager
    def task_hash
      @tasks
    end
  end
end

class RakeTaskManager
  def self.clean(name)
    Rake.application.task_hash[name.to_s] = nil
  end

  def self.define_test_task(dir)
    define_test_task_with_pattern(dir, "test/#{dir}/*_test.rb")
  end

  def self.define_spec_task(dir)
    define_spec_task_with_pattern(dir, "spec/#{dir}/*_spec.rb")
  end

  def self.task_defined?(name)
    !Rake.application.task_hash[name.to_s].nil?
  end

  def self.define_task_with_project_hooks(name)
    raise "Error: 'define_task_with_project_hooks is deprecated; just use 'overridable_task :#{task_name}'"
  end

  # run all the given tasks and aggregate all exceptions (ensuring later tasks run even if earlier ones fail)
  def self.invoke_tasks_in_aggregation(*task_names)
    exceptions = task_names.collect do |task|
      begin
        Rake::Task[task].invoke
        nil
      rescue => e
        e
      end
    end.compact

    exceptions.each {|e| puts e;puts e.backtrace }
    raise "Test failures" unless exceptions.empty?
  end

  protected
  def self.define_test_task_with_pattern(task_name, pattern)
    Rake::TestTask.new(task_name) do |t|
      t.libs << "test"
      t.pattern = pattern
      t.verbose = true
    end
  end

  def self.define_spec_task_with_pattern(task_name, pattern)
    Spec::Rake::SpecTask.new(task_name) do |t|
      t.libs << "spec"
      t.pattern = pattern
    end
  end

end