require File.dirname(__FILE__) + "/../lib/no_framework_bootstrap"

namespace :svn do
  desc "Give a warning that working copy will be deleted, then create a release branch, freeze externals on the branch and commit, and tag the frozen branch"
  task :cut do
    puts "are you sure you want to do a cut?  it will blow away any local changes."
    puts "type 'y' to do a cut"

    if $stdin.gets.chomp == 'y'
      Rake::Task['svn:cut_without_warning'].invoke
    else
      puts "skipping cut"
    end
  end

  desc "Create a release branch, freeze externals on the branch and commit, and tag the frozen branch"
  task :cut_without_warning do
    require_subversion_helper
    tag = run_subversion_task(SubversionHelper::SubversionTasks::Cut.new)
    ENV['TAG'] = tag
  end

  desc "Tag the externals (not parent project).  Uses TAG if defined, otherwise default tagname based on application and initials in DeployConfiguration"
  task :tag_externals do
    require_subversion_helper
    run_subversion_task SubversionHelper::SubversionTasks::TagExternals.new(ENV['TAG'])
  end

  desc "Copy FROM_TAG to TO_TAG for current project and all externals.  FROM_TAG must exist, and TO_TAG must not."
  task :copy_tag_including_externals do
    raise "from_tag and to_tag variables must be specified" unless from_tag && to_tag
    require_subversion_helper
    run_subversion_task SubversionHelper::SubversionTasks::CopyTagIncludingExternals.new(from_tag, to_tag)
  end

  desc "Freeze externals to TAG.  If PLUGIN_GROUP is specified, only plugins in that group will be frozen."
  task :freeze_externals_to_tag do
    require_subversion_helper
    run_subversion_task SubversionHelper::SubversionTasks::FreezeExternalsToTag.new(tag, plugin_group)
  end

  desc "Create a branch"
  task :branch do
    require_subversion_helper
    run_subversion_task SubversionHelper::SubversionTasks::Branch.new
  end

  desc "Freeze the branch"
  task :freeze_branch do
    require_subversion_helper
    run_subversion_task SubversionHelper::SubversionTasks::FreezeBranch.new
  end

  desc "Perform a cut, and then tag_externals.  This ensures that the tag created by cut is reused by tag_externals"
  task :cut_and_tag_externals do
    require_subversion_helper
    run_subversion_task SubversionHelper::SubversionTasks::Cut.new
    run_subversion_task SubversionHelper::SubversionTasks::TagExternals.new
  end

  def require_subversion_helper
    dir = File.dirname(__FILE__)
    require "#{dir}/../lib/no_framework_bootstrap"
    require "subversion_helper"
  end

  def run_subversion_task(task)
    subversion_config = YAML.load(File.open("#{File.dirname(__FILE__)}/../../../../config/subversion.yml").read)
    task.application = subversion_config['application']
    task.repository_base = subversion_config['repository_root']
    task.run
  end
end