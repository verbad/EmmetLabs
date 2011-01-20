dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A Branch Task" do
  include SubversionFunctionalHelper

  setup do
    setup_svn_fixture
    @branch = SubversionHelper::SubversionTasks::Branch.new
    @branch.initials = "aa"
    @branch.message = "the message"
    @branch.application = "project"
    @branch.repository_base = svn_project_address
  end

  specify "should create a brand new branch (not frozen)" do
    @branch.run

    current_branches = svn_subdirs(svn_branches_address)
    current_tags = svn_subdirs(svn_tags_address)
    current_branches.length.should == 1
    current_tags.length.should == 0
    new_branch_location = "#{svn_branches_address}/#{current_branches[0]}"
    external_status(svn_trunk_address, "external").should == "external #{svn_external_address}"
    external_status(new_branch_location, "external").should == "external #{svn_external_address}"
  end

end