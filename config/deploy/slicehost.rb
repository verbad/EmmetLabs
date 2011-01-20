set :deploy_to, "/u/apps/emmet"
set :rails_env, 'production' 
ssh_options[:port] = 2200

role :app, "67.23.44.120"
role :web, "67.23.44.120"
role :db, "67.23.44.120", :primary => true
set :user, "emmet"
set :branch, "production"
set :scm_verbose, true