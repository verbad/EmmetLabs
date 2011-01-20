require "db_tasks"

# (P) means it's a Pivotal addition. (2) means it's new with Rails 2 and thus we will backport it to work in 1.2.
#
# (P) db:init -> deprecated
# (P) db:init_with_environment -> deprecated
# 
# (P) db:clear -> drop and create db for RAILS_ENV
# (P) db:setup -> drop, create, and migrate dbs for test and development environments, and import fixtures into development

namespace :db do
  def tasks
    (@db_tasks ||= DbTasks.new(self))
  end

  ### deprecated tasks

  def deprecated(name)
    puts "WARNING: #{name} is deprecated, so please stop using it. Check Alex's email for more info."
  end

  desc "Drop and recreate dev and test databases and migrate - deprecated"
  task :init => :environment do
    deprecated("db:init")
    tasks.init
  end

  desc "Drop and recreate database and migrate (respects RAILS_ENV) - deprecated"
  task :init_with_environment => :environment do
    deprecated("db:init_with_environment")
    tasks.init_with_environment(ENV["RAILS_ENV"])
  end

  desc "Delete all data in the database - deprecated"
  namespace :data do
    task :delete => :environment do
      deprecated("db:data:delete")
      tasks.delete_data(RAILS_ENV)
    end
  end

  ###

  desc "Drop and recreate database"
  task :clear => :environment do
    tasks.clear
  end

  desc "Clear and migrate dev and test databases, and load fixtures into development db"
  task :setup => :environment do
    tasks.setup
  end
  
  desc "Dump the current environment's database schema and data to, e.g., db/development_dump.sql (optional param: FILE=foo.sql)"
  task :dump => :environment do
    if ENV['FILE']
      tasks.dump ENV['FILE']
    else
      tasks.dump
    end
  end
  
  desc "Load an sql file (by default db/development_dump.sql). (Optional param: FILE=foo.sql)"
  task :load => :environment do
    if ENV['FILE']
      tasks.load ENV['FILE']
    else
      tasks.load
    end
  end
  
end

