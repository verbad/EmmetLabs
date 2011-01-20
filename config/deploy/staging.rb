set :deploy_to, "/u/apps/emmet-staging" 

role :app, "emmetlabs.com"
role :web, "emmetlabs.com"
role :db, "emmetlabs.com", :primary => true
set :user, "pivotal"
set :branch, "staging"
set :scm_verbose, true 