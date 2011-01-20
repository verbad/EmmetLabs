#!/usr/bin/env ruby

require 'rubygems'

env = nil

ENV['RAILS_ENV'] = ARGV.first || 'development'

require "#{File.dirname(__FILE__)}/../config/environment"


#Relationship.find(:all).each do |r|
#		dr = r.directed_relationships[0]
#   print "\"#{dr.from.full_name}\" -- \"#{dr.to.full_name}\"\n"
#end

logins = Login.find(:all, :conditions => [ 'created_at > ? ', Time.now - 30.days ])


logins.each do |l|
  print "#{l.created_at.strftime("%b %d %H:%M")} #{l.user.unique_name} \n"
end
