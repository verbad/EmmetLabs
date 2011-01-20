#!/usr/bin/env ruby

env = nil
ENV['RAILS_ENV'] = ARGV.first || 'development'
require "#{File.dirname(__FILE__)}/../config/environment.rb"

sum = 0
print "Number of relationships: #{Relationship.find(:all).size}\n"
print "Relationships with stubs: #{Relationship.find(:all).find_all { |r| r.stub?}.size}\n"
Relationship.find(:all).inject(0) { |sum, r| sum += r.article.nil? ? 0 : r.article.word_count }
print "Total Relationship word count #{sum}\n"

print "Number of people: #{Person.find(:all).size}\n"
Person.find(:all).inject(0) { |sum, p| sum += p.biography.nil? ? 0 : p.biography.split(' ').size }
print "Total people word count: #{sum}\n"


