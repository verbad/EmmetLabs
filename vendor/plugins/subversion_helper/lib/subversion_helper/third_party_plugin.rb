class ThirdPartyPlugin
  def initialize(name, options = {})
    @name = name
    @options = options
    @prior_vendor_tag_name = options[:prior_vendor_tag_name]
    @remote_repository_root = options[:remote_repository_root]
    @repository_root = "https://svn.pivotallabs.com/subversion/plugins/third_party/#{@name}"
    @delete_local_branch_changes = !@options[:delete_local_branch_changes].nil? and @options[:delete_local_branch_changes].downcase == 'true'
    @remote_relative_path = options[:no_root_dir] ? @name : "."
  end

  attr_reader :name, :repository_root, :remote_repository_root, :options

  def update
    raise "Please provide a remote repository using REMOTE_SVN_ROOT parameter" unless @remote_repository_root
    unless @prior_vendor_tag_name
      # TODO: it's possible to automatically determine the name of the local sprout tag and corresponding vendor tag
      list_vendor_tags
      raise "Please provide the vendor tag which matches the most recent local_sprout tag listed above as the PRIOR_VENDOR_TAG_NAME parameter, so the local branch can be checked for modifications" 
    end
    check_for_local_branch_changes(@prior_vendor_tag_name)
    remote_revision = current_remote_revision
    vendor_tag_name = vendor_tag_name(remote_revision)
    if @prior_vendor_tag_name == vendor_tag_name
      raise "Vendor tag #{vendor_tag_name} already exists for the vendor branch, you cannot update to this tag."
    end
    @msg = "rake third_party:update - updated to tag #{vendor_tag_name}"
    make_new_vendor_tag_and_refresh_vendor_branch(remote_revision, vendor_tag_name)
    copy_to_local_branch(vendor_tag_name)
  end

  def install
    raise "Please provide a remote repository using REMOTE_SVN_ROOT parameter" unless @remote_repository_root
    remote_revision = current_remote_revision
    vendor_tag_name = vendor_tag_name(remote_revision)
    @msg = "rake third_party:install - plugin #{@name} installed from #{@remote_repository_root}"
    make_svn_directories
    make_new_vendor_tag_and_refresh_vendor_branch(remote_revision, vendor_tag_name)
    copy_to_local_branch(vendor_tag_name)
  end

  def local_branch_diff(vendor_tag_name = nil)
    vendor_tag_name ||= @options[:vendor_tag_name]
    if vendor_tag_name.nil?
      list_vendor_tags
      raise "Please provide the VENDOR_TAG_NAME parameter which matches the most recent local_sprout tag listed above" 
    end
    diff_output = SubversionUtils.execute("svn diff #{@repository_root}/tags/local_sprout_from_#{vendor_tag_name} #{@repository_root}/branches/local")
    puts diff_output
    return diff_output
  end
  
  def local_branch_changes_exist?(vendor_tag_name)
    !local_branch_diff(vendor_tag_name).strip.empty?
  end

  def check_for_local_branch_changes(vendor_tag_name)
    return if @delete_local_branch_changes
    return unless local_branch_changes_exist?(vendor_tag_name)
    raise "Changes exist between local branch and vendor tag '#{vendor_tag_name}.  Either manually merge the new vendor diffs, or pass the DELETE_LOCAL_BRANCH_CHANGES=true flag"  
  end

  def vendor_tags
    puts `svn ls #{@repository_root}/tags`
  end

  def list_vendor_tags
    puts "\nTags:"
    vendor_tags
    puts "\n"
  end
  
  private
  def make_svn_directories
    SubversionUtils.execute("svn mkdir #{@repository_root} -m '#{@msg}'")
    SubversionUtils.execute("svn mkdir #{@repository_root}/branches -m '#{@msg}'")
    SubversionUtils.execute("svn mkdir #{@repository_root}/tags -m '#{@msg}'")
  end

  def current_remote_revision
    remote_revision = SubversionUtils.get_revision_number(@remote_repository_root)
    say "Found remote revision #{remote_revision}"
    remote_revision
  end

  def make_new_vendor_tag_and_refresh_vendor_branch(remote_revision, vendor_tag_name)
    FileUtils.in_fresh_tempdir do
      export_current_vendor_onto_current_dir(remote_revision)
      import_vendor_tag(vendor_tag_name)
    end
    replace_vendor_branch(vendor_tag_name)
  end

  def checkout_latest_from_local_vendor_branch
    say "Checking out latest from local vendor branch"
    SubversionUtils.checkout("#{@repository_root}/branches/vendor")
  end

  def export_current_vendor_onto_current_dir(remote_revision)
    say "Exporting current vendor onto current dir"
    SubversionUtils.execute("svn export #{@remote_repository_root} #{@remote_relative_path} --force --revision=#{remote_revision}")
  end

  def import_vendor_tag(vendor_tag_name)
    say "Importing vendor tag #{vendor_tag_name}"
    SubversionUtils.execute("svn import . #{@repository_root}/tags/#{vendor_tag_name} -m '#{@msg}'")
  end

  def vendor_tag_name(remote_revision)
    @options[:vendor_tag_name] || "vendor_rev_#{remote_revision}"
  end

  def replace_vendor_branch(vendor_tag_name)
    say "Copying tag #{vendor_tag_name} to vendor branch"
    if @prior_vendor_tag_name
      SubversionUtils.execute("svn rm #{@repository_root}/branches/vendor " +
        "-m '#{@msg}'")
    end
    SubversionUtils.execute("svn cp #{@repository_root}/tags/#{vendor_tag_name} #{@repository_root}/branches/vendor " +
      "-m '#{@msg}'")
  end
  
  def copy_to_local_branch(vendor_tag_name)
    if SubversionUtils.exists?("#{@repository_root}/branches/local")
      say "Removing old local branch"
      SubversionUtils.execute("svn rm #{@repository_root}/branches/local -m '#{@msg}'")
    end

    sprout_tag_name = "local_sprout_from_#{vendor_tag_name}"
    sprout_tag_url = "#{@repository_root}/tags/#{sprout_tag_name}"
    say "Recording sprout tag local_sprout_from_#{vendor_tag_name}"
    SubversionUtils.execute("svn cp #{@repository_root}/tags/#{vendor_tag_name} #{sprout_tag_url} -m '#{@msg}'")
    say "Creating local branch from tag #{sprout_tag_name}"
    SubversionUtils.execute("svn cp #{sprout_tag_url} #{@repository_root}/branches/local -m '#{@msg}'")
  end

  def say(msg)
    puts msg
  end

end