dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe SubversionHelper::SubversionTasks::CopyTagIncludingExternals do
  it "should tell the SubversionHelper to copy_tag_including_externals using env['FROM_TAG'] and env['TO_TAG'] for from and to tags" do
    @task = SubversionHelper::SubversionTasks::CopyTagIncludingExternals.new('fromtag', 'totag')
    @task.application = application = "the_application"
    @task.repository_base = repository_base = "the_repository_base"
    @task.initials = initials = "initials"

    helper = mock("helper")
    SubversionHelper.should_receive(:new).with(repository_base, application).and_return(helper)
    helper.should_receive(:copy_tag_including_externals).with('fromtag', 'totag', initials)

    @task.run
  end

  it "should raise an error if from tag is undefined" do
    lambda{ SubversionHelper::SubversionTasks::CopyTagIncludingExternals.new(nil, 'totag').run }.should raise_error
  end

  it "should raise an error if to tag is undefined" do
    lambda {SubversionHelper::SubversionTasks::CopyTagIncludingExternals.new('fromtag', nil).run}.should raise_error
  end
end

