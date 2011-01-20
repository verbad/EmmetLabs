dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A Freeze Branch task with initials and message" do
  specify %Q{should Cleanup
             AND create a Branch with default initials and message
             AND Switch code to the branch
             AND Freeze externals
             AND Commit change to server
             AND Cleanup
             AND Switch code back to head
             AND Update code} do

    branch = SubversionHelper::SubversionTasks::FreezeBranch.new
    branch.initials = "aa"
    branch.message = "the message"
    branch.application = application = "the_application"
    branch.repository_base = repository_base = "the_repository_base"

    helper = mock("helper")
    SubversionHelper.should_receive(:new).with(repository_base, application, true).and_return(helper)

    helper.should_receive(:cleanup).twice.ordered
    helper.should_receive(:branch).with("aa", "the message").ordered.and_return("the_branch")
    helper.should_receive(:switch).with("the_branch").ordered
    helper.should_receive(:freeze_externals).ordered
    helper.should_receive(:commit).with("branched and frozen").ordered
    # TODO: Uncomment when rspec supports multiple ordered expectations
    #helper.should_receive(:cleanup).ordered
    helper.should_receive(:switch_to_trunk).ordered
    helper.should_receive(:update).ordered

    branch.run
  end
end
