require File.dirname(__FILE__) + "/../lib/bootstrap/rake_task_manager"

RakeTaskManager.clean("db:fixtures:load")
namespace :db do
  namespace :fixtures do
    # This differs from the standard db:fixtures:load only in that it turns off foreign key checking.
    desc "Load fixtures into the current environment's database.  Load specific fixtures using FIXTURES=x,y"
    task :load => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      ActiveRecord::Base.connection.update('SET FOREIGN_KEY_CHECKS = 0') #nw - Turn off foreign keys while doing this
      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'test', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
        Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
      end
      ActiveRecord::Base.connection.update('SET FOREIGN_KEY_CHECKS = 1') #nw - Turn ON foreign keys afterwards
    end
  end

  def tasks
    DbTasks.new(self)
  end
end

# This is overwritten to work with Virtual Enumerations.
RakeTaskManager.clean("db:test:prepare")
namespace :db do
  namespace :test do
    task :prepare => :environment
  end
end
