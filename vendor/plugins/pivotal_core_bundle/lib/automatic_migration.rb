class AutomaticMigration
  def self.local_schema_version
    begin
      version_rows = (ActiveRecord::Base.connection.execute 'select version from schema_info')
      version_rows.each do |version_columns|
        return version_columns.first.to_i
      end
    rescue
      return -1
    end
    return 0
  end

  def self.migrate_if_necessary
    version = local_schema_version
    return if version == -1  # db has not yet been created, so abort cleanly
    puts "Schema version is #{version}"
    desired = Migrator.max_schema_version
    if (version < desired)
      puts "Migrating schema to version #{desired}"
      Migrator.migrate(Migrator.max_schema_version)
    end
  end
end
