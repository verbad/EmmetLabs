namespace :third_party do
  desc "Updates the vendor and local branches of a third party plugin to the latest and greatest from that vendor"
  task :update do
    third_party_plugin.update
  end

  desc "Sets up a Pivotal version of a vendor's plugin in our third party plugin area"
  task :install do
    third_party_plugin.install
  end

  # desc "Creates a local branch from a particular vendor tag"
  # task :make_local_branch do
  #   third_party_plugin.make_local_branch
  # end

  desc "Displays local branch diffs from a particular vendor tag"
  task :local_branch_diff do
    third_party_plugin.local_branch_diff
  end

  desc "Displays list of vendor tags"
  task :vendor_tags do
    third_party_plugin.vendor_tags
  end

  def requires
    dir = File.dirname(__FILE__)
    require "#{dir}/../../pivotal_core_bundle/lib/no_framework_bootstrap"
    require "#{dir}/../../pivotal_core_bundle/lib/ruby_core_extensions"
    require "subversion_helper"
  end

  def third_party_plugin
    requires
    plugin_name = ENV['NAME']
    raise "You need a NAME" unless plugin_name
    ThirdPartyPlugin.new(plugin_name,
      :remote_repository_root => ENV['REMOTE_SVN_ROOT'],
      :no_root_dir => ENV['NO_ROOT_DIR'],
      :prior_vendor_tag_name => ENV['PRIOR_VENDOR_TAG_NAME'],
      :vendor_tag_name => ENV['VENDOR_TAG_NAME'],
      :delete_local_branch_changes => ENV['DELETE_LOCAL_BRANCH_CHANGES'])
  end
end