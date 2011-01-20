dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A Branch task where initials AND message are defined" do
  specify "should tell the SubversionHelper to branch with initials and message" do
    branch = SubversionHelper::SubversionTasks::Branch.new
    branch.initials = "aa"
    branch.message = "the message"
    branch.application = application = "the_application"
    branch.repository_base = repository_base = "the_repository_base"

    helper = mock("helper")
    SubversionHelper.should_receive(:new).with(repository_base, application).and_return(helper)
    helper.should_receive(:branch).with("aa", "the message")

    branch.run
  end
end
