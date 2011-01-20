require 'capistrano/recipes/deploy/scm/subversion'

module ::Capistrano
  module Deploy
    module SCM
      class Subversion < Base
        # Using svn switch -- the more general version of svn update -- to account for the
        # fact that the repository root will change when switching between tags
        def sync(revision, destination)
          scm(:switch, verbose, authentication, "-r#{revision}", repository, destination) + ' && ' +
            scm(:update, verbose, authentication, "-r#{revision}", destination)
        end
      end
    end
  end
end

# replacement for "set :repository" which supports tags.
# Note: you should omit the "/trunk" part of the URL  
def set_repository(repository_root)
  set :repository_root, repository_root
  begin
    set :repository, "#{repository_root}/tags/#{tag}"
  rescue
    begin
      if head == 'true'
        set :repository, "#{repository_root}/trunk"
      else
        raise
      end
    rescue
      raise "Please deploy with -S tag=<tag name> or -S head=true"
    end
  end
end