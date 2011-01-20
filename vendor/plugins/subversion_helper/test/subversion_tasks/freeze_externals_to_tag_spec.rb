dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe SubversionHelper::SubversionTasks::FreezeExternalsToTag do
  it "should tell the SubversionHelper to freeze_externals_to_tag" do
    @task = SubversionHelper::SubversionTasks::FreezeExternalsToTag.new('mytag', nil)
    @task.application = application = "the_application"
    @task.repository_base = repository_base = "the_repository_base"

    helper = mock("helper")
    SubversionHelper.should_receive(:new).with(repository_base, application).and_return(helper)
    helper.should_receive(:freeze_externals_to_tag).with('mytag', nil)

    @task.run
  end

  it "should tell the SubversionHelper to freeze_externals_to_tag for a specified PLUGIN_GROUP" do
    @task = SubversionHelper::SubversionTasks::FreezeExternalsToTag.new('mytag', 'plugin_group')
    @task.application = application = "the_application"
    @task.repository_base = repository_base = "the_repository_base"

    helper = mock("helper")
    SubversionHelper.should_receive(:new).with(repository_base, application).and_return(helper)
    helper.should_receive(:freeze_externals_to_tag).with('mytag', 'plugin_group')

    @task.run
  end
end

