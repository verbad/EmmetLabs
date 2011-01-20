#!/usr/bin/env ruby

require 'rubygems'

env = nil

ENV['RAILS_ENV'] = ARGV.first || 'development'

require "#{File.dirname(__FILE__)}/../config/environment"


#Relationship.find(:all).each do |r|
#		dr = r.directed_relationships[0]
#   print "\"#{dr.from.full_name}\" -- \"#{dr.to.full_name}\"\n"
#end

actions = UserAction.find_all_by_action('create')

actions.each do |a|
  if a.loggable_type == 'Relationship'
    r = Relationship.find(:first, :conditions => "id = #{a.loggable_id}")
    next if r.nil?
    dr = r.directed_relationships.find(:first)
    print "#{a.created_at.strftime("%b %d %H:%M")} #{a.user.unique_name} created relationship between #{dr.to.full_name} and #{dr.from.full_name}\n"
  elsif a.loggable_type == 'Person'
    begin
      person = Person.find(a.loggable_id)
    rescue ActiveRecord::RecordNotFound
      person = Person.new
      person.first_name = 'DELETED'
      person.middle_name = 'PERSON'
      person.last_name = a.loggable_id
    end
    print  "#{a.created_at.strftime("%b %d %H:%M")} #{a.user.unique_name} created #{person.full_name}\n"
  end
end
