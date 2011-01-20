dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe DbTasks, "#test_environments" do
  it "includes test" do
    DbTasks.new(nil).send(:test_environments).should == ['test']
  end

  describe "with TEST_WORKERS" do
    before do
      Object.redefine_const(:TEST_WORKERS, 2)
    end

    after do
      Object.send(:remove_const, :TEST_WORKERS)
    end

    it "includes extra test worker environments" do
      DbTasks.new(nil).send(:test_environments).should == ['test', 'test0', 'test1']
    end
  end

  describe "with custom ENVIRONMENTS" do
    attr_reader :old_environments
    before do
      @old_environments = Object::ENVIRONMENTS
      DbTasks.redefine_const(:ENVIRONMENTS, ['test', 'selenium_test'])
    end

    after do
      DbTasks.redefine_const(:ENVIRONMENTS, old_environments)
    end

    it "has an ENVIRONMENTS constant that is as a prototype for the test environments" do
      tasks = DbTasks.new(nil)
      tasks.send(:test_environments).should == ['test', 'selenium_test']
    end
  end
end

