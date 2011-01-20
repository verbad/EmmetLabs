require "capistrano_extensions"
module CapistranoExtensions
  module Commands
    class AfterUpdateCode < Command
      self.task_options[:roles] = [:web]
      def execute
        run "cd #{release_path} && rake RAILS_ENV=#{rails_env} asset:packager:build_all"
      end
    end
  end
end