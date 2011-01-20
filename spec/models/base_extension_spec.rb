require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveRecord::Base, " when our extension to it is loaded by the spec helper" do
  it "allows us to find the last created record" do
    new_person = Person.create!(:common_name => 'Yogi Bear', :summary => 'some text')
    Person.find_last_created.should == new_person
  end
end