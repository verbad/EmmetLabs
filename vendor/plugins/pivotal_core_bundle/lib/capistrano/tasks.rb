namespace :deploy do
  namespace :db do
    set(:properties) { ::YAML.load_file("config/database.yml")[stage.to_s] }

    task :backup, :roles => :db do
      on_rollback { deploy.db.rollback }
      run "mysqldump -u #{properties['username']} -p#{properties['password']} #{properties['database']} > #{previous_release}/dump.sql" rescue nil
    end

    task :rollback, :roles => :db do
      run "mysql -u #{properties['username']} -p#{properties['password']} #{properties['database']} < #{previous_release}/dump.sql" rescue nil
    end

    task :setup, roles => :db do
      run "mysql -uroot -ppassword -e 'create database if not exists `#{properties['database']}`'"
    end
    
    task :teardown, roles => :db do
      run "mysql -uroot -ppassword -e 'drop database if exists `#{properties['database']}`'"
    end
  end

  # use mongrel_cluster rather than 'spin' script
  task :start, :roles => :app do
    run "#{deploy_to}/current/config/mongrel/mongrel_cluster restart #{deploy_to}/current/config/mongrel/#{stage}"
  end

  task :stop, :roles => :app do
    run "#{deploy_to}/current/config/mongrel/mongrel_cluster stop #{deploy_to}/current/config/mongrel/#{stage}"
  end
  
  task :restart, :roles => :app do
    deploy.start
  end

  desc "gem installer"
  task :geminstaller, :roles => :app do
    sudo "geminstaller -c #{current_release}/config/geminstaller.yml"
  end

  task :asset_packager, :role => :web do
    run "cd #{current_release} && rake RAILS_ENV=#{stage} asset:packager:build_all"
  end

  task :transactional do
    transaction { migrations }
  end
  
  # version.txt is a file that, using a subversion keyword, indicates the repository of the current release.
  task :refresh_version_txt do
    version_txt_path = "#{strategy.send(:repository_cache)}/public/version.txt"
    run "rm #{version_txt_path} && svn up #{version_txt_path}"
    run "cp #{version_txt_path} #{current_release}/public/version.txt"
  end

  task :default do
    deploy.transactional
  end
end

task :deploy_for_cc do
  deploy.setup
  deploy.transactional
end

