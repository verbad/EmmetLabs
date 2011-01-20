require 'rubygems'
require "spec"

dir = File.dirname(__FILE__)
require "#{dir}/../../pivotal_core_bundle/lib/test_framework_bootstrap"
require "subversion_helper"
require 'tmpdir'
require 'fileutils'

module SubversionFunctionalHelper
  def setup_svn_fixture
    @tmpdir = Dir.tmpdir
    timestamp = Time.now.to_i.to_s
    repository_dirname = "#{timestamp}/repository"
    checkout_dirname = "#{timestamp}/checkout"
    @svn_repository_dir = "#{@tmpdir}/#{repository_dirname}"
    @svn_repository_address = "file:///#{@svn_repository_dir}"
    @svn_checkout_dir = "#{@tmpdir}/#{checkout_dirname}"
    FileUtils.mkdir_p(@svn_repository_dir)
    FileUtils.mkdir_p(@svn_checkout_dir)
    `svnadmin create #{@svn_repository_dir}`
    `svn mkdir #{svn_project_address} -m ''`
    `svn mkdir #{svn_trunk_address} -m ''`
    `svn mkdir #{svn_trunk_address}/public -m ''`
    `svn mkdir #{svn_branches_address} -m ''`
    `svn mkdir #{svn_tags_address} -m ''`
    `svn mkdir #{svn_external_address} -m ''`
    `svn co #{svn_trunk_address} #{@svn_checkout_dir}`

    FileUtils.cd(@svn_checkout_dir)
    `svn propset svn:externals 'external #{svn_external_address}' .`
    `svn ci -m ''`
    `svn up`
  end

  def external_status(location, dir_name)
    current_externals_raw = `svn propget svn:externals #{location}`
    current_externals = current_externals_raw.split("\n")
    current_externals[0]
  end

  def current_info(project_repository_subdir)
    `svn info #{svn_project_address}/#{project_repository_subdir}`
  end

  def svn_project_address
    @svn_repository_address + "/project"
  end

  def svn_external_address
    @svn_repository_address + "/external"
  end

  def svn_branches_address
    svn_project_address + "/branches"
  end

  def svn_trunk_address
    svn_project_address + "/trunk"
  end

  def svn_tags_address
    svn_project_address + "/tags"
  end

  def svn_subdirs(location)
    ls_result = `svn ls #{location}`
    ls_result.split.collect {|listing| listing.gsub("/", "")}
  end

end
