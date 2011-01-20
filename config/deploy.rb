load_paths << 'vendor/plugins/pivotal_core_bundle/lib/capistrano'
load 'deploy_framework'
load_paths << 'lib/capistrano'
load 'emmet_tasks'

set :scm, :git
set :repository,  "git@emmetlabs.com:emmet.git"
set :deploy_via, :remote_cache
set :application, 'emmet'