############# Begin GemInstaller config - see http://geminstaller.rubyforge.org
require "rubygems"
require "geminstaller"

# Path(s) to your GemInstaller config file(s)
config_paths = "#{File.expand_path(RAILS_ROOT)}/config/geminstaller.yml"

# Arguments which will be passed to GemInstaller
args = "--config #{config_paths}"

# The 'exceptions' flag determines whether errors encountered while running GemInstaller
# should raise exceptions (and abort Rails), or just return a nonzero return code
args += " --exceptions"

if ENV['CRUISE_PROJECT_NAME']
  # you can change the output defaults under cruise if you want
  # args += " --geminstaller-output=error,install,info"
end

# This will use sudo by default on all non-windows platforms, but requires an entry in your
# sudoers file to avoid having to type a password.  It can be omitted if you don't want to use sudo.
# See http://geminstaller.rubyforge.org/documentation/documentation.html#dealing_with_sudo
args += " --sudo" unless RUBY_PLATFORM =~ /mswin/

# The 'install' method will auto-install gems as specified by the args and config
# !!! Only run on CI (which runs as root or has NOPASSWD in sudoers) for now until the root-owned-gems issue is resolved
# !!! See http://geminstaller.rubyforge.org/documentation/documentation.html#dealing_with_sudo for details
require 'socket'
if Socket.gethostname =~ /ashbury-linux/ or Socket.gethostname =~ /ci.pivotal/ # or Socket.gethostname =~ /camp/
  # p "Invoking GemInstaller.run, ENV['RAILS_GEM_VERSION'] = #{ENV['RAILS_GEM_VERSION']} - BUT env vars will not be passed via sudo!"
  GemInstaller.run(args)
end

# The 'autogem' method will automatically add all gems in the GemInstaller config to your load path, using the 'gem'
# or 'require_gem' command.  Note that only the *first* version of any given gem will be loaded.
# p "Invoking GemInstaller.autogem, ENV['RAILS_GEM_VERSION'] = #{ENV['RAILS_GEM_VERSION']}"
GemInstaller.autogem(args)
############# End GemInstaller config