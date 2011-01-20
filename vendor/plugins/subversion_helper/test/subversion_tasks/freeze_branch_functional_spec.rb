dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A Freeze Branch Task" do
  include SubversionFunctionalHelper

  setup do
    setup_svn_fixture
    @freezebranch = SubversionHelper::SubversionTasks::FreezeBranch.new
    @freezebranch.initials = "aa"
    @freezebranch.message = "the message"
    @freezebranch.application = "project"
    @freezebranch.repository_base = svn_project_address
  end

  specify "should freeze externals in a brand new branch" do
    @freezebranch.run

    current_branches = svn_subdirs(svn_branches_address)
    current_tags = svn_subdirs(svn_tags_address)
    current_branches.length.should == 1
    current_tags.length.should == 0
    new_branch_location = "#{svn_branches_address}/#{current_branches[0]}"
    external_status(svn_trunk_address, "external").should match(/external\s*#{Regexp.escape(svn_external_address)}/)
    external_status(new_branch_location, "external").should match(/external\s*-r7\s*#{Regexp.escape(svn_external_address)}/)
  end

end