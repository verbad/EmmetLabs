# This creates a duplicate of the database config for a db config as defined in database.yml.
# For example, if the "test" database is named "myapp_test", 
# for clone number 0, the new environment is named "test0", and the database is "myapp_test0".
# All other settings are preserved (esp. username and password).
module ActiveRecord
  class Base
    def self.clone_config(original_config, worker_number)
      original = configurations[original_config.to_s]
      raise "Could not find conguration '#{original_config}' to clone" if original.nil?
      worker_config = original.dup
      worker_config["database"] += worker_number.to_s
      configurations["#{original_config}#{worker_number}"] = worker_config
    end
  end
end

# (P) means it's a Pivotal addition. (2) means it's new with Rails 2 and thus we will backport it to work in 1.2.
class DbTasks
  ENVIRONMENTS = ['test']
  def initialize(rake)
    @rake = rake
  end

  # (P) db:init - deprecated
  def init
    connect_to('development')
    clear_database
    migrate_database
    dump
    test_environments.each do |test_db|      
      if test_db =~ /([0-9]+)$/
        clone_test_config($1.to_i)
      end
      connect_to(test_db)
      clear_database
      load
    end
  end

  # (P) db:init_with_environment - deprecated
  def init_with_environment(environment)
    connect_to(environment)
    clear_database
  end

  # (P) db:clear -> drop and create db for RAILS_ENV
  def clear
    clear_database
  end
  
  # (P) db:setup -> drop, create, and migrate dbs for test and development environments, and import fixtures into development
  def setup
    init
    connect_to 'development'
    load_fixtures
  end

  def dump(file = "#{RAILS_ROOT}/db/#{environment}_dump.sql")    
    puts "Dumping #{database} into #{file}"
    system "mysqldump #{database} -u#{username} #{password_parameter} --default-character-set=utf8 > #{file}"
  end
  
  def load(sql_file = "#{RAILS_ROOT}/db/development_dump.sql")
    puts "Loading #{sql_file} into #{database}"
    query('SET foreign_key_checks = 0')
    sql_file = File.expand_path(sql_file)
    IO.readlines(sql_file).join.split(";").each do |statement|
      query(statement.strip) unless statement.strip == ""
    end
    query('SET foreign_key_checks = 1')
  end

  # (P) db:delete_data - deprecated
  def delete_data(environment)
    connect_to environment
    puts "Initializing #{environment} database"
    tables_data = `mysql -D #{database} -u#{username} #{password_parameter} -e "show tables;"`
    tables = tables_data.split("\n")[1..-1]
    tables.each do |table|
      execute "mysql -D #{database} -u#{username} #{password_parameter} -e 'TRUNCATE TABLE #{table};'"
    end
  end

  protected

  def clone_test_config(worker_num)
    ActiveRecord::Base.clone_config("test", worker_num)
  end
  
  def connect_to(environment)
    ActiveRecord::Base.establish_connection(environment)
    @environment = environment
    Object.const_set(:RAILS_ENV, environment)
    # Note: don't set ENV['RAILS_ENV'] since that gets passed down to invoked tasks (including 'rake test')
  end
  
  def environment
    (@environment ||= RAILS_ENV)
  end
  
  def test_environments
    environments = ENVIRONMENTS.dup
    if Object.const_defined?(:TEST_WORKERS)
      TEST_WORKERS.times do |worker_num|
        environments << "test#{worker_num}"
      end
    end
    environments
  end
  
  def load_fixtures
    puts "Loading fixtures into #{environment}"
    Rake::Task["db:fixtures:load"].invoke
  end

  def clear_database
    puts "Clearing #{environment} database"
    sql = "drop database if exists #{database}; create database #{database} character set utf8;"    
    cmd = %Q|mysql -u#{username} #{password_parameter} -e "#{sql}"|
    # puts "executing #{cmd.inspect}"
    system(cmd)
  end
  
  def migrate_database
    puts "Migrating #{environment} database"
    ActiveRecord::Migration.verbose = false
    Rake::Task["db:migrate"].invoke
  end

  def config(env = environment)
    ActiveRecord::Base.configurations[env]
  end
  
  def query(sql)
    ActiveRecord::Base.connection.execute(sql)
  end

  def database
    config["database"]
  end
  
  def username
    config["username"]
  end
  
  def password
    config["password"]
  end
  
  def password_parameter
    if password.nil? || password.empty?
      ""
    else
      "-p#{password}"
    end
  end
  
  def execute(cmd)
    puts "\t#{cmd}"
    unless system(cmd)
      puts "\tFailed with status #{$?.exitstatus}"
    end
  end

  def system(cmd)
    @rake.send(:system, cmd)
  end
end
