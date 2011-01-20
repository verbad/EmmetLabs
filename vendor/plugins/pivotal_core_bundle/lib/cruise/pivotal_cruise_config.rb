module Pivotal
  class CruiseConfig
    def self.config(project)
      # TODO: this isn't tested, because we don't want to poolute the environment variables
      # To test it, we should make this return a data structure, then assign the env vars in the actual cruise_config.rb.  Feel free.
      ENV['CRUISE_PROJECT_NAME'] = project.name
      if project.name =~ /rails[_-](.*)$/ # project_rails_1.2.5.7919
        rails_gem_version = $1
        rails_gem_version.gsub!('-','.')
        ENV['RAILS_GEM_VERSION'] = rails_gem_version
      end
    end
  end
end
