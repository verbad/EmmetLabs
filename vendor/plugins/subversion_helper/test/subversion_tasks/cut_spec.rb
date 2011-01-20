 dir = File.dirname(__FILE__)
 require "#{dir}/../spec_helper"

context "A Cut task with a SubversionHelper error" do
  specify %Q{should cleanup
             AND switch back to head
             AND update} do

    cut = SubversionHelper::SubversionTasks::Cut.new
    cut.initials = "aa"
    cut.message = "the message"
    cut.application = application = "the_application"
    cut.repository_base = repository_base = "the_repository_base"

    helper = mock("helper")
    SubversionHelper.should_receive(:new).with(repository_base, application, true).and_return(helper)
    helper.should_receive(:cleanup).twice.ordered
    helper.should_receive(:branch).with("aa", "the message").ordered.and_return("")
    helper.should_receive(:create_version_file).ordered.and_raise(RuntimeError.new("our error"))

    # Here are the specifications
    # TODO: Uncomment when rspec supports multiple ordered expectations
    # helper.should_receive(:cleanup).ordered
    helper.should_receive(:switch_to_trunk).ordered
    helper.should_receive(:update).ordered

    lambda {cut.run}.should raise_error(RuntimeError, "our error")
  end
end

context "A Cut task" do
  specify %Q{should cleanup
             AND create a Branch
             AND Create a Version File
             AND Switch to the branch
             AND Freeze the externals
             AND Commit the changes
             AND Tag the branch
             AND Cleanup
             AND Write a message
             AND Cleanup
             AND Switch back to HEAD
             AND Update} do

    cut = SubversionHelper::SubversionTasks::Cut.new
    cut.initials = "aa"
    cut.message = "the message"
    cut.application = application = "the_application"
    cut.repository_base = repository_base = "the_repository_base"

    helper = mock("helper")
    SubversionHelper.should_receive(:new).with(repository_base, application, true).and_return(helper)
    helper.should_receive(:cleanup).exactly(2).times.ordered
    branch_path = "https://repository/project/branches/release_name"
    helper.should_receive(:branch).with("aa", "the message").ordered.and_return(branch_path)
    helper.should_receive(:create_version_file).ordered
    helper.should_receive(:switch).with(branch_path).ordered
    helper.should_receive(:freeze_externals).ordered
    helper.should_receive(:commit).with("branched and frozen").ordered
    helper.should_receive(:tag_from_branch).with("release_name").ordered
    # TODO: Uncomment when rspec supports multiple ordered expectations
    # helper.should_receive(:cleanup).ordered
    helper.should_receive(:execute).with(/release_name/)

    # TODO: Uncomment when rspec supports multiple ordered expectations
    # helper.should_receive(:cleanup).ordered
    helper.should_receive(:switch_to_trunk).ordered
    helper.should_receive(:update).ordered

    cut.run.should == "release_name"
  end
end
