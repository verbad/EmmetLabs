set :stages, Dir["config/deploy/*"].map {|stage| File.basename(stage, '.rb')}
require 'capistrano/ext/multistage'
load 'subversion_extensions'
load 'tasks'



#begin
#  subversion_yaml = ::YAML.load_file("config/subversion.yml")
#rescue => e
#  raise "Please put a subversion.yml into your project's config directory with application and repository_root keys."
#end
#set :application, subversion_yaml["application"]
#set_repository(subversion_yaml["repository_root"] || "https://svn.pivotallabs.com/subversion/#{application}")
set(:rails_env) { stage }

before "deploy:migrate", "deploy:db:backup"
#before "deploy:finalize_update", "deploy:refresh_version_txt"
before "deploy:db:backup", "deploy:web:disable"
after "deploy:migrations", "deploy:web:enable"
after "deploy:migrations", "deploy:cleanup"