dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe SubversionHelper::SubversionTasks::TagExternals do
  it ", when env['TAG'] is specified, should tell the SubversionHelper to tag_externals with tag" do
    @tag_externals = SubversionHelper::SubversionTasks::TagExternals.new('mytag')
    @tag_externals.application = application = "the_application"
    @tag_externals.repository_base = repository_base = "the_repository_base"

    helper = mock("helper")
    SubversionHelper.should_receive(:new).with(repository_base, application).and_return(helper)
    helper.should_receive(:tag_externals).with('mytag')

    @tag_externals.run
  end


  it ", when env['TAG'] is not specified, should tell the SubversionHelper to tag_externals_with_timestamped_tagname with initials" do
    @tag_externals = SubversionHelper::SubversionTasks::TagExternals.new
    @tag_externals.application = application = "the_application"
    @tag_externals.repository_base = repository_base = "the_repository_base"
    @tag_externals.initials = 'initials'

    helper = mock("helper")
    SubversionHelper.should_receive(:new).with(repository_base, application).and_return(helper)
    helper.should_receive(:tag_externals_with_timestamped_tagname).with('initials')

    @tag_externals.run
  end
end

