dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A Task" do
  specify "should default initials to 'ci'" do
    task = SubversionHelper::SubversionTasks::Task.new
    task.initials.should == 'ci'
  end

  specify "should default message to 'Creating branch via rake task'" do
    task = SubversionHelper::SubversionTasks::Task.new
    task.message.should == 'Creating branch via rake task'
  end
end
