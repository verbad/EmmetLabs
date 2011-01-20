#Copyright (c) 2005 Tobias Luetke
#
#Permission is hereby granted, free of charge, to any person obtaining
#a copy of this software and associated documentation files (the
#"Software"), to deal in the Software without restriction, including
#without limitation the rights to use, copy, modify, merge, publish,
#distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so, subject to
#the following conditions:
#
#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


module Migrator
  mattr_accessor :offer_migration_when_available
  @@offer_migration_when_available = true

  def self.migrations_path
    "#{RAILS_ROOT}/db/migrate"
  end

  def self.available_migrations
    if RUBY_PLATFORM =~ /mswin32/
      # TODO: This is a bug that happens during a deploy. Need to report this to Ruby.
      Dir["#{migrations_path}/[0-9]*_*.rb"].sort_by { |name| name.scan(/\d+/).first.to_i }
    else
      `ls -x1 #{migrations_path}`.sort_by { |name| name.scan(/\d+/).first.to_i }
    end
  end

  def self.current_schema_version
    ActiveRecord::Migrator.current_version rescue 0
  end

  def self.max_schema_version
#    Transforms:
#     ["C:/dev/workspace/bringo/config/../db/migrate/059_migrations_001_to_059.rb",
#      "C:/dev/workspace/bringo/config/../db/migrate/060_migration_test.rb"]
#    Into:
#     60
    available_migrations.last.split('/').last.first(3).to_i rescue 0
  end

  def self.db_supports_migrations?
    ActiveRecord::Base.connection.supports_migrations?
  end

  def self.migrate(version = nil)
      ActiveRecord::Migrator.migrate("#{migrations_path}/", version)
  end

  def self.migrate_respecting_version
      # NOTE: this is required to be called from the applications environment.rb
      # or else db:migrate will still migrate to the highest version
      # when it calls the prerequisite environment task, which will cause failures if
      # a subsequent version has bugs.

      # WARNING: If there is another unrelated 'VERSION' environment variable set,
      # you will have migrate to the wrong version when starting the app
      version = ENV['VERSION'] ? ENV['VERSION'].to_i : max_schema_version
      migrate(version)
  end

  def self.up(version = max_schema_version)
      ActiveRecord::Migrator.up("#{migrations_path}/", version)
  end

  def self.down(version = 0)
      ActiveRecord::Migrator.down("#{migrations_path}/", version)
  end

  def self.down_one
      down(max_schema_version - 1)
  end
end