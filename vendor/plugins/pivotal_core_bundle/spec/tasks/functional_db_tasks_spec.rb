dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

def tmp
  ["/tmp", "c:/tmp", "c:/temp"].each do |path|
    return path if File.exist?(path)
  end
end

describe "db.rake", "(functional spec)" do
  attr_accessor :app
  
  before :all do
    @app = "#{tmp}/blog"
    
    unless Object.const_defined?(:ActiveRecord)
      require 'active_record'
      ActiveRecord::Base.configurations = YAML::load(ERB.new(IO.read("#{dir}/../../config/database.yml")).result)
      ActiveRecord::Base.establish_connection("test")
    end
    
    config = ActiveRecord::Base.configurations["test"]
    username = config["username"]
    password = config["password"]

    FileUtils.rm_rf(app)
    system "rails -d mysql #{app}"
    Dir.chdir(app) do
      system "./script/generate model user name:string"
      system "./script/generate model article title:string created_on:date body:text author_id:integer  state_id:integer"
      system "./script/generate model state name:string"

      # Remove fixture file for states, so loading fixtures doesn't wipe it
      FileUtils.rm("test/fixtures/states.yml")

      # pre-seed some states
      states_migration = """
class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string :name
      t.timestamps
    end
    State.create(:name => 'draft')
    State.create(:name => 'published')
    State.create(:name => 'archived')
    State.create(:name => 'deleted')
  end

  def self.down
    drop_table :states
  end
end
      """
      FileUtils.touch("db/migrate/003_create_states.rb")
      File.open("db/migrate/003_create_states.rb", "w") do |f|
        f.print states_migration
      end
      # add our username and password to the test app's config
      munge("$_.gsub!(/password:.*$/, \"password: #{password}\");" + 
            "$_.gsub!(/username:.*$/, \"username: #{username}\");", 
            "config/database.yml")
    end
    FileUtils.cp("#{dir}/../../tasks/db.rake", "#{app}/lib/tasks/")
    FileUtils.cp("#{dir}/../../lib/db_tasks.rb", "#{app}/lib")
    FileUtils.cp_r("#{dir}/../../lib/bootstrap", "#{app}/lib/")    
  end
  
  def munge(script, file)
    system "ruby -p -i -e '" + script + "' \"#{app}/#{file}\""
  end

  def structure
    rake "db:structure:dump"
    structure_path = File.expand_path("#{app}/db/development_structure.sql")
    IO.read(structure_path)
  end
  
  def rake(cmd)
    system "rake --trace RAILS_ENV=development #{cmd}"
  end

  it "migrates" do
    Dir.chdir(app) do
      rake "db:migrate"
      s = structure
      s.should =~ /CREATE TABLE `users`/
      s.should =~ /CREATE TABLE `articles`/
      s.should =~ /CREATE TABLE `states`/
    end
  end

  it "clears" do
    Dir.chdir(app) do
      rake "db:migrate"
      rake "db:clear"
      structure.should == ""
    end
  end
  
  it "loads fixtures" do
    Dir.chdir(app) do
      rake "db:migrate"
      rake "db:fixtures:load"
      `script/runner -e development 'puts User.count'`.to_i.should == 2
      `script/runner -e development 'puts Article.count'`.to_i.should == 2
      `script/runner -e development 'puts State.count'`.to_i.should == 4
    end
  end
  
  it "setup clears and migrates both development and test dbs, and loads fixtures into development" do
    Dir.chdir(app) do
      rake "db:setup"
      s = structure
      s.should =~ /CREATE TABLE `users`/
      s.should =~ /CREATE TABLE `articles`/
      `script/runner -e development 'puts User.count'`.to_i.should == 2
      `script/runner -e development 'puts Article.count'`.to_i.should == 2
      `script/runner -e development 'puts State.count'`.to_i.should == 4

      `script/runner -e test 'puts User.count'`.to_i.should == 0
      `script/runner -e test 'puts Article.count'`.to_i.should == 0
      `script/runner -e test 'puts State.count'`.to_i.should == 4
    end
  end
  
  it "setup creates and migrates test worker dbs" do
    Dir.chdir(app) do
      begin
        FileUtils.cp("config/environments/development.rb", "config/environments/development.rb.bak")
        File.open("config/environments/development.rb", "a") do |f|
          f.puts
          f.puts("TEST_WORKERS=2")
        end
        rake "db:setup"
        
        # no longer
        File.exist?("config/environments/test0.rb").should be_false
        File.exist?("config/environments/test1.rb").should be_false
        IO.read("config/database.yml").should_not =~ /^test0:/
        IO.read("config/database.yml").should_not =~ /^test1:/
        
        script = """
        require \"db_tasks.rb\";
        ActiveRecord::Base.clone_config(:test, 0);
        ActiveRecord::Base.establish_connection(:test0);
        puts User.count;
        """
        `script/runner -e test '#{script}'`.chomp.should == '0'
      ensure
        FileUtils.mv("config/environments/development.rb.bak", "config/environments/development.rb", :force => true)
      end
    end
  end
end
