dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

describe "An execute command" do
  it "should not throw an exception for an ordinary execute command" do
    lambda {SubversionUtils.execute("svn info https://svn.pivotallabs.com/subversion")}.should_not raise_error
  end

  it "should throw an exception for syntax errors" do
    lambda {SubversionUtils.execute("idontknow")}.should(
      raise_error(Exception))
  end

  it "should structure the exception for svn errors" do
    lambda {SubversionUtils.execute("svn info https://svn.pivotallabs.com/notvalid")}.should(
      raise_error(Exception, '"svn info https://svn.pivotallabs.com/notvalid" failed with status=256'))
  end
end

describe "The exists? command" do
  it "should return false if the path throws an exception for svn info" do
    SubversionUtils.should_receive(:execute).with("svn info https://svn.pivotallabs.com/notvalid").
      and_return {raise Exception.new("\"svn info https://svn.pivotallabs.com/notvalid\" failed with status=256")}
    SubversionUtils.should_not be_exists("https://svn.pivotallabs.com/notvalid")
  end

  it "should return false if the path does not exist" do
    SubversionUtils.should_receive(:execute).with("svn info https://svn.pivotallabs.com/subversion/notvalid").
      and_return("https://svn.pivotallabs.com/subversion/notvalid:  (Not a valid URL)")
    SubversionUtils.should_not be_exists("https://svn.pivotallabs.com/subversion/notvalid")
  end

  it "should return true if svn info finds information" do
    SubversionUtils.should_receive(:execute).with("svn info https://svn.pivotallabs.com/subversion").
      and_return("Path: subversion\n" +
      "URL: https://svn.pivotallabs.com/subversion\n" +
      "Repository Root: https://svn.pivotallabs.com/subversion\n" +
      "Repository UUID: ff112490-4206-0410-a331-ceb4712babc9\n" +
      "Revision: 45690\n" +
      "Node Kind: directory\n" +
      "Last Changed Author: pivotal\n" +
      "Last Changed Rev: 45690\n" +
      "Last Changed Date: 2007-06-13 10:23:05 -0700 (Wed, 13 Jun 2007)\n")
    SubversionUtils.should be_exists("https://svn.pivotallabs.com/subversion")
  end
end