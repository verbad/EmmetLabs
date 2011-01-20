dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A Freeze and Cut Task" do
  include SubversionFunctionalHelper

  setup do
    setup_svn_fixture
    @cut = SubversionHelper::SubversionTasks::Cut.new
    @cut.initials = "aa"
    @cut.message = "the message"
    @cut.application = "project"
    @cut.repository_base = svn_project_address
  end

  specify "should create a branch and a tag and freeze the externals" do
    @cut.run

    current_branches = svn_subdirs(svn_branches_address)
    current_tags = svn_subdirs(svn_tags_address)
    current_branches.length.should == 1
    current_tags.length.should == 1
    current_branches.should == current_tags
    new_branch_location = "#{svn_branches_address}/#{current_branches[0]}"
    new_tag_location = "#{svn_tags_address}/#{current_tags[0]}"
    external_status(svn_trunk_address, "external").should match(/external\s*#{Regexp.escape(svn_external_address)}/)
    external_status(new_branch_location, "external").should match(/external\s*-r7\s*#{Regexp.escape(svn_external_address)}/)
    external_status(new_tag_location, "external").should match(/external\s*-r7\s*#{Regexp.escape(svn_external_address)}/)
  end

end