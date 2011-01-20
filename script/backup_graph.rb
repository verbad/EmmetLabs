#!runner

require 'optparse'

dbConfig = Rails.configuration.database_configuration[Rails.env]


$debug = false
$db = dbConfig['database']
$dbUser = dbConfig['username']
$dbPass = dbConfig['password']
$remove = false

OptionParser.new do |opt|
  opt.banner = "Usage backup_graph.rb [-v] [-d db] [-u user] <backup_file> <person_id_or_param> [<user_id_or_param>...]"
  opt.on('-v', '--verbose', 'Verbose output') { |v| $debug = v }
  opt.on('-d', '--database DBNAME', 'The database to use') {|db| $db = db }
  opt.on('-u', '--user DBUSER', 'The database username') {|u| $dbUser = u }
  opt.on('-r', '--remove', 'Remove entities from the database') {|r| $remove = r}
  opt.parse!(ARGV)
end

puts "DB: #{$db}" if $debug

$schema = Hash.new

outFile = ARGV.shift
$out = File.open(outFile, "w")

def backup(table, ids, col = 'id', addWHERE = '')
  return if ids.empty?
  cmd = [%w{mysqldump -t -c -e -u}, $dbUser, "-p=#{$dbPass}", $db, table, 
         "--where=#{col} IN (#{ids.to_a.sort.join ', '}) #{addWHERE}"].flatten
  puts cmd.join(" ") if $debug
  if fork.nil?
    $stdout.reopen($out)
    exec *cmd
  end
  Process.wait
  unless $? == 0
    $stderr.puts "An error occurred. Please correct it."
    exit $?
  end
  $schema[table] = true;
end

cache = Hash.new

ARGV.each do |pid|
  if pid =~ /^\d+$/
    begin
      p = Person.find(pid)
    rescue ActiveRecord::RecordNotFound
    end
  else
    p = Node.find_person_or_entity_by_param(pid)
  end
  if p.nil?
    $stderr.puts "Couldn't find Person/Entity #{pid}, skipping it."
    next
  end
  puts "Backing up graph for #{p.to_param}"
  drs = p.directed_relations_set(-1, cache)
  
  pids = Set.new
  eids = Set.new
  aids = Set.new
  
  relationships = Set.new
  cats = Set.new
  meta = Set.new
  
  drs.each do |dr| 
    [[dr.from_type, dr.from_id], [dr.to_type, dr.to_id]].each do |a|
      if (a[0] == "Entity")
        eids << a[1]
      else
        pids << a[1]
      end
    end
    aids.add(*dr.from.asset_ids) unless dr.from.asset_ids.empty?
    aids.add(*dr.to.asset_ids) unless dr.to.asset_ids.empty?
    
    relationships << dr.relationship_id 
    cats << dr.category_id
    meta << dr.category.metacategory_id
  end
  backup 'people', pids
  backup 'entities', eids
  backup 'milestones', pids, 'node_id', "AND node_type = 'Person'"
  backup 'milestones', eids, 'node_id', "AND node_type = 'Entity'"
  backup 'taggings', pids, 'taggable_id', "AND taggable_type = 'Person'"
  backup 'taggings', eids, 'taggable_id', "AND taggable_type = 'Entity'"
  backup 'directed_relationships', drs.map {|dr| dr.id}
  backup 'relationships', relationships
  backup 'relationship_categories', cats
  backup 'relationship_metacategories', meta
  backup 'relationship_articles', relationships, 'relationship_id'
  backup 'assets', aids
  backup 'assets_associations', pids, 'associate_id', "AND associate_type = 'Person'" unless aids.empty?
  backup 'assets_associations', eids, 'associate_id', "AND associate_type = 'Entity'" unless aids.empty?
  backup 'user_actions', pids, 'loggable_id', "AND loggable_type = 'Person'"
  backup 'user_actions', eids, 'loggable_id', "AND loggable_type = 'Entity'"
  backup 'user_actions', relationships, 'loggable_id', "AND loggable_type = 'Relationship'"

  if $remove
    [[pids, Person], [eids, Entity]].each do |ids, klass|
      ids.to_a.sort.each do |id|
        begin
          item = klass.find(id)
          puts "Removing #{item.to_param}" if $debug
          item.destroy
        rescue ActiveRecord::RecordNotFound
          $stderr << "#{klass} ##{id} not found\n"
        end
      end
    end
  end
end
