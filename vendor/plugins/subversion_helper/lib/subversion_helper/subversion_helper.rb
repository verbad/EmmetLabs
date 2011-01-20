class SubversionHelper

  def initialize(repository_base, application, trace=false)
    @repository_trunk = repository_base + "/trunk"
    @repository_base = repository_base
    @application = application
    @trace = trace
  end
  
  def branch(initials="ci", message="automated branching")
    branch_url = build_branch_url_for_base(timestamped_tagname(initials))
    log "Branching #{branch_url}"
    success = copy(@repository_trunk, branch_url, message)
    return (success ? branch_url : false)
  end

  def copy(from_url, to_url, message, revision = nil)
    revision_option = build_revision_option(revision)
    log "Copying #{from_url} #{revision_option} to #{to_url}.  Message: #{message}"
    execute("svn copy #{revision_option} #{from_url} #{to_url} -m '#{message}'")
    to_url
  end

  def switch_to_trunk
    switch(@repository_trunk)
  end

  def freeze_externals
    perform_for_dirs_containing_externals do |parent|
      new_externals = []
      perform_for_externals_under(parent) do |parent, single_external|
        new_external = build_external_line(
          single_external[:name],
          single_external[:url],
          single_external[:revision]
        )
        new_externals << new_external
      end
      new_externals_string = new_externals.join("\n")
      set_externals_for_parent(parent, new_externals_string)
    end
  end
  
  def freeze_externals_to_tag(tag, plugin_group = nil)
    perform_for_dirs_containing_externals do |parent|
      parent_externals_changed = false
      new_externals = []

      external_data = external_data_under(parent, false)
      external_data.each do |single_external|
        name = single_external[:name]
        original_url = single_external[:url]
        external_plugin_group = plugin_group_for(original_url)
        if plugin_group.nil? || plugin_group == external_plugin_group
          parent_externals_changed = true
          tag_url = build_tag_url(original_url, tag)
          raise "Tag does not exist: #{tag_url}" unless uri_exists?(tag_url)
          new_external = build_external_line(name, tag_url)
        else
          revision_option = build_revision_option(single_external[:revision])
          new_external = build_external_line(name, original_url, single_external[:revision])
        end
        new_externals << new_external
      end
      if parent_externals_changed
        new_externals_string = new_externals.join("\n")
        set_externals_for_parent(parent, new_externals_string)
      end
    end
  end
  
  def set_externals_for_parent(parent, new_externals_string)
      log "Setting externals for #{parent}:\n#{new_externals_string}"
      prop_set_svn_externals(parent, new_externals_string)
  end
  
  def tag_externals_with_timestamped_tagname(initials)
    tag = timestamped_tagname(initials)
    tag_externals(tag, initials)
  end

  def tag_externals(tag, message = nil)
    perform_for_all_externals do |parent, single_external|
      original_url = single_external[:url]
      revision = single_external[:revision]
      tag_url = build_tag_url(original_url, tag)
      message ||= ''
      specific_message = "#{message} - automated tagging of #{original_url} at revision #{revision} as tag #{tag_url}"
      log "Tagging external under #{parent}: #{specific_message}"
      tag(original_url, tag_url, specific_message, revision)
    end

  end
  
  def copy_tag_including_externals(from_tag, to_tag, message = nil)
    log "Copying tag for base and all externals.  FROM_TAG=#{from_tag}, TO_TAG=#{to_tag}"
    verify_tag_exists_for_base(from_tag)
    verify_tag_does_not_exist_for_base(to_tag)
    verify_tag_exists_for_externals(from_tag)
    verify_tag_does_not_exist_for_externals(to_tag)
    copy_tag_for_base(from_tag, to_tag, message)
    copy_tag_for_externals(from_tag, to_tag, message)
  end

  def dirs_containing_externals
    status_lines = execute("svn st")
    status_regexp = /^X\s+(.*)\s*$/
    parents = []
    status_lines.split("\n").each do |line|
      matchdata = status_regexp.match(line)
      if matchdata
        external = matchdata[1]
        external_file_paths = external.split("/")
        external_file_paths.pop
        parent = external_file_paths.join("/")
        parent = "." if parent == ""
        parents << parent
      end
    end
    parents.uniq
  end

  def log(msg)
    puts msg
  end

  def verify_tag_exists_for_base(tag)
    tagged_base_url = build_tag_url_for_base(tag)
    raise "Tag does not exist: #{tagged_base_url}" unless uri_exists?(tagged_base_url)
  end

  def verify_tag_does_not_exist_for_base(tag)
    tagged_base_url = build_tag_url_for_base(tag)
    raise "Tag already exists: #{tagged_base_url}" if uri_exists?(tagged_base_url)
    log "Ignore the previous 'Not a valid URL' error for #{tagged_base_url}, or else write the code to capture stderr" 
  end

  def verify_tag_exists_for_externals(tag)
    perform_for_all_externals do |parent, single_external|
      tagged_url = build_tag_url(single_external[:url], tag)
      raise "Tag does not exist: #{tagged_url}" unless uri_exists?(tagged_url)
    end
  end

  def verify_tag_does_not_exist_for_externals(tag)
    perform_for_all_externals do |parent, single_external|
      tagged_url = build_tag_url(single_external[:url], tag)
      raise "Tag already exists: #{tagged_url}" if uri_exists?(tagged_url)
      log "Ignore the previous 'Not a valid URL' error for #{tagged_url}, or else write the code to capture stderr" 
    end
  end

  def copy_tag_for_base(from_tag, to_tag, message = nil)
    from_tag_url = build_tag_url_for_base(from_tag)
    to_tag_url = build_tag_url_for_base(to_tag)
    specific_message = "#{message} - Copying existing tag #{from_tag_url} to new tag #{to_tag_url}"
    tag(from_tag_url, to_tag_url, specific_message)
  end

  def copy_tag_for_externals(from_tag, to_tag, message = nil)
    perform_for_all_externals do |parent, single_external|
      original_url = single_external[:url]
      from_tag_url = build_tag_url(original_url, from_tag)
      to_tag_url = build_tag_url(original_url, to_tag)
      specific_message = "#{message} - Copying existing tag #{from_tag_url} to new tag #{to_tag_url}"
      tag(from_tag_url, to_tag_url, specific_message)
    end
  end

  def external_data_under(parent, include_unfrozen_revisions = true)
    external_prop = prop_get("svn:externals", parent)
    current_externals = external_prop.split("\n")
    external_data = []
    current_externals.each do |external_line|
      next if external_line.strip == ""
      if match_data = external_line.match(/(\S+)\s+-r([0-9]+)\s+(\S+)/)
        external_data << {:name => match_data[1], :revision => match_data[2], :url => match_data[3]}
      else
        match_data = external_line.match(/(\S+)\s+(\S+)/)
        if match_data.nil?
          puts "Unable to match externals line #{external_line.inspect}"
          next
        end
        filename = match_data[1]
        external = File.join(parent, filename)
        external_hash = {:name => filename, :url => match_data[2]}
        if include_unfrozen_revisions
          rev = get_revision_number(external)
          external_hash[:revision] = rev
        end
        external_data << external_hash
      end
    end
    external_data
  end


  def prop_set_svn_externals(parent, new_externals)
    prop_set("svn:externals", parent, new_externals)
  end

  def tag(original_url, tag_url, message, revision = nil)
    log "Tagging #{original_url} as #{tag_url}, optional revision #{revision}" 
    copy(original_url, tag_url, message, revision)
  end

  def tag_from_branch(branch_name, message="automated tagging")
    branch_url = build_branch_url_for_base(branch_name)
    tag_url = build_tag_url_for_base(branch_name)
    tag(branch_url, tag_url, message)
  end

  # TODO: this is unused, but it would be good to expose it as a task 
  # and make it call tag_externals (which currently tags externals,
  # but not the parent project)
  def tag_with_name(tag_name, message="automated tagging")
    tag_url = build_tag_url_for_base(tag_name)
    tag(@repository_trunk, tag_url, message)
  end
 
  def get_revision_number(target)
    SubversionUtils.get_revision_number(target)
  end

  def info(target)
    info = execute(generate_info_command(target))
    return info
  end

  def uri_exists?(target)
    info(target).to_s.include?("URL: #{target}")
  end

  def can_call_uri_exists?
    svn_version && (svn_version >= "1.3.1")
  end

  def svn_version
    raw_output = `svn --version`
    regex = /svn, version ([0-9]+\.[0-9]+\.[0-9]+)/
    matches = regex.match(raw_output)
    matches ? matches[1] : nil
  end

  def prop_get(property, target)
    value = execute "svn propget #{property} #{target}"
    return value.strip
  end
  
  def prop_set(property, target, value)
    execute "svn propset #{property} '#{value}' #{target}"
  end
  
  def switch(target_branch)
    execute "svn switch #{target_branch}"
  end
  
  def commit(message)
    execute "svn ci -m '#{message}'"
  end

  def cleanup()
    execute "svn cleanup"
  end
  
  def update()
    execute "svn update"
  end

  def create_version_file()
    if file_exists?("public/version.txt")
      return
    end

    # NOTE: we used to have $Date$ and $Revision$ in version.txt.  However, these are the date and revision the
    # version.txt file itself was LAST CHANGED, which never changes (since this file is never updated and checked in).
    # So, we will only put the $HeadURL$, which WILL change based on the URL (tag/branch) that the project is checked out from.
    execute "echo -e '$HeadURL$' > public/version.txt"
    execute "svn add public/version.txt"
    execute "svn propset svn:keywords \"Date Revision HeadURL\" public/version.txt"
    execute "svn ci public/version.txt -m \"Adding revision file\""
  end

  def delete_and_revert(file)
    execute generate_delete_and_revert_command(file)
  end

  def execute(cmd)
    SubversionUtils.execute(cmd, @trace)
  end

  def generate_delete_and_revert_command(file)
    "rm #{file}; svn up #{file}"
  end
  
  def build_revision_option(revision)
    revision_option = revision ? "-r#{revision}" : ''
  end

  def build_tag_url(original_url, tag)
    match_data = original_url.match /(.*)\/(trunk|branches|tags)(\/.*)?$/
    raise "Unexpected subversion url format, does not contain trunk/branches/tags: #{original_url}" unless match_data
    "#{match_data[1]}/tags/#{tag}"
  end

  def build_tag_url_for_base(tag)
    "#{@repository_base}/tags/#{tag}"
  end

  def build_branch_url_for_base(branch)
    "#{@repository_base}/branches/#{branch}"
  end

  def plugin_group_for(original_url)
    return 'pivotal-common' if original_url.match(/pivotal-common/)
    
    match_data = original_url.match /\/plugins\/(.*?)\/.*/
    return 'unidentified_plugin_group' unless match_data
    match_data[1]
  end

  def build_external_line(name, url, revision = nil)
    "#{name}\t\t#{build_revision_option(revision)}\t#{url}"
  end

  protected
  def time
    @time ||= Time
  end

  def generate_info_command(target)
    target.nil? ? "svn info" : "svn info #{target}"
  end

  def timestamped_tagname(initials)
    "#{@application}-#{time.now.strftime('%Y%m%d%H%M%S')}-#{initials}"
  end

  def file_exists?(filename)
    return File.exists?(filename)
  end

  def perform_for_dirs_containing_externals
    dirs_containing_externals.each do |parent|
      yield(parent)
    end
  end
  
  def perform_for_all_externals(&block)
    dirs_containing_externals.each do |parent|
      perform_for_externals_under(parent, &block)
    end
  end
  
  def perform_for_externals_under(parent, &block)
    external_data = external_data_under(parent)
    external_data.each do |single_external|
      block.call(parent, single_external)
    end
  end
end