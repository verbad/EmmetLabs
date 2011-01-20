namespace :utility do
  namespace :db do
    set(:properties) { ::YAML.load_file("config/database.yml")[stage.to_s] }
    set(:staging_db) { ::YAML.load_file("config/database.yml")['staging'] }
    set(:production_db) { ::YAML.load_file("config/database.yml")['production'] }
    set :backup_file, 'dump.sql'
    
    task :production_to_staging, :roles => :db do
      on_rollback { run "rm -f #{backup_file}" }
      run "mysqldump --add-drop-table -u #{production_db['username']} -p#{production_db['password']} #{production_db['database']} > #{backup_file}"
      run "mysql -u #{staging_db['username']} -p#{staging_db['password']}  < #{backup_file}"
      run "rm -f #{backup_file}"
    end
    
    task :load_named_dbdump, :roles => :db do
      begin 
        print "mysql -u #{properties['username']} -p#{properties['password']} #{properties['database']} < #{source_file}"
      rescue
        raise "Please deploy with -S source_file=<mysql_source_file>"
      end
    end
  end
end



