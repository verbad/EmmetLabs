set :deploy_to, "/u/apps/emmet-demo" 

role :app, "emmetlabs.com"
role :web, "emmetlabs.com"
role :db, "emmetlabs.com", :primary => true
set :user, "pivotal"
set :scm_verbose, true 