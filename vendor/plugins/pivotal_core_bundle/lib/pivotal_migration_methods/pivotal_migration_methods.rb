module PivotalMigrationMethods
  # This class holds helper functions for making common migration things easier
  def add_foreign_key_constraint(table, constraint_name, foreign_key_col, references_table, references_col = "id", cascade_delete = :restrict)
    execute "ALTER TABLE #{table.to_s} ADD CONSTRAINT #{constraint_name.to_s} FOREIGN KEY (#{foreign_key_col.to_s}) REFERENCES #{references_table.to_s}(#{references_col.to_s})" +
      " ON DELETE " + cascade_delete.to_s.upcase
  end

  def drop_foreign_key_constraint(table, constraint_name)
    execute "ALTER TABLE #{table.to_s} DROP FOREIGN KEY #{constraint_name.to_s}"
  end

  def alter_charset(database, charset)
    begin
      execute "ALTER DATABASE #{database} DEFAULT CHARACTER SET #{charset}"
    rescue Exception => e
      puts "Warning: " + e
    end
  end

  def reload_table(table_name)
    execute "DELETE FROM #{table_name}"
    sql_file = File.new(File.dirname(__FILE__) + "/#{table_name}.sql")
    execute sql_file.readline($;)
  end

  def grant_access(database, user, password, host='localhost', permissions='ALL')
    begin
      execute "GRANT #{permissions.to_s} ON #{database.to_s}.* TO '#{user.to_s}'@'#{host.to_s}' IDENTIFIED BY '#{password.to_s}'"
    rescue Exception => e
      puts "Warning: " + e
    end
  end
end

module ActiveRecord
  class Migration
    extend PivotalMigrationMethods
  end
end