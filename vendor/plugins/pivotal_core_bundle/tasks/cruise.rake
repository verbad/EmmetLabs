require File.dirname(__FILE__) + "/../lib/no_framework_bootstrap"

# xqt is leetspeek for "execute" which means "perform this system command". We need an inscrutable name
# for this function since there are a half dozen other global "execute" methods which we don't want to override
def xqt(cmd)
  unless (@initialized)
    FileUtils.rm("stdout.log", :force => true)
    FileUtils.rm("stderr.log", :force => true)
    @initialized = true
  end
  CommandLine.execute cmd, :stdout => "stdout.log", :stderr => "stderr.log"
end

# steps to get ccrb running
# 1. add local environment to
#     - config/environment/local.rb
#         copy config/environment/development.rb
#     - config/database.yml
#         local:
#           <<: *development
#     - config/rake_constants.rb
#
# 2. get 'rake cruise' to work
# 3. get box w/ cruise on it
# 4. ./cruise add <name> -u <svn-url>
# 5. ./cruise start

overridable_task :cruise do
  Rake::Task['cruise:environment'].invoke
  Rake::Task['db:setup'].invoke
  Rake::Task['alltests'].invoke
  Rake::Task['cruise:cut'].invoke
  Rake::Task['cruise:deploy'].invoke
end

namespace :cruise do

  task :environment do
    ENV['keep_browser_open_on_failure'] = "false"
  end

  task :cut_and_tag_externals do
    Rake::Task['cruise:cut'].invoke
    Rake::Task['svn:tag_externals'].invoke
  end

  task :cut do
    require 'subversion_helper'
    if ENV['CC_BUILD_ARTIFACTS']
      Rake::Task['svn:cut_without_warning'].invoke
    else
      Rake::Task['svn:cut'].invoke
    end
    tag = ENV['TAG']
    puts "created tag #{tag}"
    File.open("#{ENV['CC_BUILD_ARTIFACTS']}/#{tag}", "w") {|f| f << tag } if ENV['CC_BUILD_ARTIFACTS']
  end

  task :deploy do
    if has_capistrano_extensions_plugin? # old, capistrano 1.4 world
      ENV['RAILS_ENV'] = 'local'

      # TODO: this require has to be here and not at the top of the file, or else demo/prod deploys will fail
      # because capistrano is not installed on the target server.  The root cause is the static config class
      require 'capistrano_extensions'

      # Setting DeployConfiguration.delete_base_on_initial_setup to false will make the deploy step go a lot faster,
      # because it does not have to do a full checkout.  However, it will also make the deploy step fail if there are any
      # leftover directories due to svn:externals not getting cleaned up (which happens a lot).  So, we leave it to true.
      #  One possible workaround would be to do an svn status to find unversioned ('?') files and delete them before attempting
      # the deploy.
      DeployConfiguration.delete_base_on_initial_setup = true

      Rake::Task['remote:initial_setup'].invoke

      Rake::Task[:deploy].invoke
    else # new, Capistrano 2.0 world
      xqt "cap local deploy_for_cc -S head=true"
    end
  end

  task :start_servants => ['jsunit:start_servant', 'selenium:start_servant']

  task :stop_servants => ['jsunit:stop_servant', 'selenium:stop_servant']
end

desc "Convenience alias to be used by Continuous Integration"
overridable_task :ci do
  Rake::Task["db:init_and_test"].invoke
end

def has_capistrano_extensions_plugin?
  File.exists?(File.dirname(__FILE__) + "/../../capistrano_extensions")
end
