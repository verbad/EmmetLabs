desc "The stuff that cruise will execute.  Make your own, local cruise task based on this one for your project."
task :cruise_sample do
   SampleCruiseTask.new(self).run
end

class SampleCruiseTask
  def initialize(rake)
    @rake = rake
  end

  def run
    execute "time ntpdate pool.ntp.org"
    execute "time geminstaller --sudo --config=#{RAILS_ROOT}/config/geminstaller.yml --rubygems-output=all --geminstaller-output=all"
    execute "time rake db:init --trace"

    execute "time rake testspec --trace"

    
    suite12_result = system("time rake jsunit:test TEST=suite12 --trace")
    suite34_result = system("time rake jsunit:test TEST=suite34 --trace")
    suite56_result = system("time rake jsunit:test TEST=suite56 --trace")
    
    unless (suite12_result and suite34_result and suite56_result)
      raise("Build failed")
    end    
 
    execute("time rake selenium:test --trace")
    execute("time rake cruise:cut cruise:deploy " +
      ['CC_BUILD_ARTIFACTS'].collect { |var| "#{var}=#{ENV[var]}" }.join(" ") +
    " --trace")
  end

  def execute(cmd)
   system(cmd) || raise("Build failed")
  end
end
