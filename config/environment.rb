RAILS_GEM_VERSION = '2.1.1'
require File.join(File.dirname(__FILE__), 'boot')

POST_LOAD_BLOCKS = []

Rails::Initializer.run do |config|
  config.action_controller.session_store = :active_record_store
  config.load_paths += %W(
      #{RAILS_ROOT}/vendor/docdiff
    )
  
  config.gem "mongrel"
  # config.gem "mongrel_cluster"
  
  config.gem "capistrano"
  # config.gem "capistrano-ext", :lib => 'capistrano/ext/:lib' #TODO: If we need a cap extension, replace :lib with it
  
  config.gem "libxml-ruby", :lib => "xml/libxml"
  
  config.gem "BlueCloth", :lib => "bluecloth"
  
  config.gem "rmagick", :lib => "RMagick"
  
  config.gem "mechanize"
  
  config.gem "aws-s3", :lib => "aws/s3"
  
  config.gem "compass" # depends on the haml plugin
  
  config.gem "mbleigh-acts-as-taggable-on", :source => "http://gems.github.com", :lib => "acts-as-taggable-on"
  
  config.gem "desert"
end
POST_LOAD_BLOCKS.each { |proc| proc.call } # now add this if needed

include ERB::Util
require "action_controller/session/active_record_store"
require "array_extensions"
require "date_extensions"
require "string_extensions"
require "erb"
require "net/http"
require "xml/libxml"
require "docdiff"
require "migrator"
AUTOMATIC_MIGRATION = true
if Object.const_defined?(:AUTOMATIC_MIGRATION) && AUTOMATIC_MIGRATION
  Migrator.migrate(Migrator.max_schema_version)
  puts "Migrator: max version based on upgrade files available is #{Migrator.max_schema_version}"
else
  puts "Migrator: Automatic Migrations turned off!!!  See config/environment.rb"
end

ExceptionNotifier.exception_recipients = %w(david@emmetlabs.com erik@emmetlabs.com)
ExceptionNotifier.sender_address = %("Emmet Error Mailer" <crashes@emmet.com>)
ExceptionNotifier.email_prefix = "[Crash in #{RAILS_ENV}] "

Haml::Template.options[:attr_wrapper] = '"'

ASSET_WORKER = Asset::Worker::Local.new

ActionController::Base.session_options[:session_expires] = nil

AMAZON_SUBSCRIPTION_ID = "0DTQ5AAFKR6KRRM94JR2"
AMAZON_ASSOCIATE_ID = "emmetlabscom-20"