dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

describe "subversion helper fixture", :shared => true do
  before do
    @application = "foo"
    @repository_base = "svn+ssh://pivotal@subversion.pivotaltracker.com/subversion/#{@application}"
    @repository_trunk = @repository_base + "/trunk"
    @helper = SubversionHelper.new(@repository_base, @application)
  end
end

describe "A Subversion Helper" do
  it_should_behave_like("subversion helper fixture")
  setup do
    def @helper.execute(cmd, trace = false)
      raise "Neutered execute - you probably wanted to mock it"
    end
    def @helper.file_exists?
      raise "Neutered file_exists?"
    end
    def @helper.log(msg)
      # ignore
    end
    @mock_time = mock('mock_time')
    @helper.stub!(:time).and_return(@mock_time)
  end

  it "branch" do
    expected_time = Time.local(2006, 'Jan', 1, 02, 3, 40)
    @mock_time.should_receive(:now).once.and_return(expected_time)

    expected_initials = "ii"
    expected_message = "expected message"
    expected = %r{svn copy\s*#{Regexp.escape(@repository_trunk)} #{Regexp.escape(@repository_base)}/branches/#{@application}-20060101020340-#{expected_initials} -m '#{expected_message}'}
    expected_results = "#{@repository_base}/branches/#{@application}-20060101020340-#{expected_initials}"
    @helper.should_receive(:execute).once.with(expected).and_return(expected_results)
    created_branch = @helper.branch(expected_initials, expected_message)
    created_branch.should == expected_results
  end

  it "tag" do
    expected_message = "expected message"
    original_url = 'original_url'
    tag_url = 'tag_url'
    expected = /svn copy\s*#{original_url} #{tag_url} -m '#{expected_message}'/
    @helper.should_receive(:execute).once.with(expected).and_return("exec output")
    created_tag = @helper.tag(original_url, tag_url, expected_message)
    created_tag.should == tag_url
  end

  it "copy" do
    expected_message = "expected message"
    from_url = 'from_url'
    to_url = 'to_url'
    expected = %r{svn copy\s*#{from_url} #{to_url} -m '#{expected_message}'}
    @helper.should_receive(:execute).once.with(expected).and_return("exec output")
    created_url = @helper.copy(from_url, to_url, expected_message)
    created_url.should == to_url
  end

  it "copy with revision" do
    expected_message = "expected message"
    from_url = 'from_url'
    to_url = 'to_url'
    revision = '12345'
    expected = "svn copy -r#{revision} #{from_url} #{to_url} -m '#{expected_message}'"
    @helper.should_receive(:execute).once.with(expected).and_return("exec output")
    created_url = @helper.copy(from_url, to_url, expected_message, revision)
    created_url.should == to_url
  end

  it "tag with revision" do
    expected_message = "expected message"
    original_url = 'original_url'
    tag_url = 'tag_url'
    revision = '12345'
    expected = "svn copy -r#{revision} #{original_url} #{tag_url} -m '#{expected_message}'"
    @helper.should_receive(:execute).once.with(expected).and_return("exec output")
    created_tag = @helper.tag(original_url, tag_url, expected_message, revision)
    created_tag.should == tag_url
  end

  it "tag_from_branch" do
    name = "tag_name"
    expected_message = "expected message"
    expected = %r{svn copy\s*#{Regexp.escape(@repository_base)}/branches/#{name} #{Regexp.escape(@repository_base)}/tags/#{name} -m '#{expected_message}'}
    expected_results = "#{@repository_base}/tags/#{name}"
    @helper.should_receive(:execute).once.with(expected).and_return(expected_results)
    created_tag = @helper.tag_from_branch(name, expected_message)
    created_tag.should == expected_results
  end

  it "tag_with_name" do
    name = "tag_name"
    expected_message = "expected message"
    expected = %r{svn copy\s*#{Regexp.escape(@repository_trunk)} #{Regexp.escape(@repository_base)}/tags/#{name} -m '#{expected_message}'}
    expected_results = "#{@repository_base}/tags/#{name}"
    @helper.should_receive(:execute).once.with(expected).and_return(expected_results)
    created_tag = @helper.tag_with_name(name, expected_message)
    created_tag.should == expected_results
  end

  it "get_revision_number" do
    target = "some_file"
    expected_results = "1234\n"
    SubversionUtils.should_receive(:execute).once.
      with("svn info #{target} | grep Revision | cut -f 2 -d' '").
      and_return(expected_results)
    @helper.get_revision_number(target).should == expected_results.chomp
  end

  it "prop_get" do
    @helper.should_receive(:execute).once.
      with("svn propget some_prop some_file").
      and_return("property value\n\n")
    actual_value = @helper.prop_get("some_prop", "some_file")
    actual_value.should == "property value"
  end

  it "prop_set" do
    target = "some_file"
    property = "some_prop"
    value = "some_value"
    expected = "svn propset #{property} '#{value}' #{target}"
    expected_results = ""
    @helper.should_receive(:execute).once.with(expected).and_return(expected_results)
    @helper.prop_set(property, target, value).should == expected_results
  end

  it "switch" do
    @helper.should_receive(:execute).once.
      with("svn switch some_branch")
    @helper.switch("some_branch")
  end

  it "switch_to_trunk" do
    @helper.should_receive(:execute).once.
      with("svn switch #{@repository_base}/trunk")
    @helper.switch_to_trunk
  end

  
  it "commit" do
    message = "some_message"
    expected_results = ""
    expected = "svn ci -m '#{message}'"
    @helper.should_receive(:execute).once.with(expected).and_return(expected_results)
    @helper.commit(message).should == expected_results
  end

  it "freeze_externals__should_freeze_all_externals_in_directory" do
    external_parent = "vendor/plugins"
    external_data = [
      {:name => 'foo',
       :revision => '4',
       :url => "repository_location_foo"
      },
      {:name => 'bar',
       :revision => '6',
       :url => "repository_location_bar"
      }
    ]

    helper_should_perform_for_dir_containing_externals(external_parent, external_data)
 
    helper_should_propset_externals(external_parent, /foo\s*-r4\s*repository_location_foo\nbar\s*-r6\s*repository_location_bar/)
    @helper.freeze_externals
  end

  it "#freeze_externals_to_tag should freeze all externals to the specified tag" do
    tag = "mytag"
    external_parent = "vendor/plugins"
    plugin = "user"
    original_url = "https://svn.pivotallabs.com/subversion/plugins/socialitis/#{plugin}/trunk/#{plugin}"
    external_data = [
      {:name => plugin,
       :revision => '4',
       :url => original_url
      }
    ]

    @helper.should_receive(:dirs_containing_externals).and_return([external_parent])
    @helper.should_receive(:external_data_under).with(external_parent, false).and_return(external_data)
    @helper.stub!(:uri_exists?).and_return(true)
    expected_tag_url = "https://svn.pivotallabs.com/subversion/plugins/socialitis/user/tags/#{tag}"
    helper_should_propset_externals(external_parent, /#{plugin}\s*#{expected_tag_url}/)
    @helper.freeze_externals_to_tag(tag)
  end

  it "#freeze_externals_to_tag, if plugin_group is specified, should only freeze externals in group" do
    tag = "mytag"
    external_parent = "vendor/plugins"
    plugin_group = "socialitis"
    plugin = "user"
    plugin_not_in_group = "do_not_touch"
    original_url = "https://svn.pivotallabs.com/subversion/plugins/#{plugin_group}/#{plugin}/trunk/#{plugin}"
    original_url_not_in_group = "https://svn.pivotallabs.com/subversion/plugins/pivotal_core/#{plugin_not_in_group}/trunk/#{plugin_not_in_group}"
    external_data = [
      {:name => plugin,
       :revision => '4',
       :url => original_url
      },
      {:name => plugin_not_in_group,
       :url => original_url_not_in_group
      }
    ]

    @helper.should_receive(:dirs_containing_externals).and_return([external_parent])
    @helper.should_receive(:external_data_under).with(external_parent, false).and_return(external_data)
    @helper.stub!(:uri_exists?).and_return(true)
    expected_tag_url = "https://svn.pivotallabs.com/subversion/plugins/socialitis/user/tags/#{tag}"
    helper_should_propset_externals(external_parent, /#{plugin}\s*#{expected_tag_url}\n#{plugin_not_in_group}\s*#{original_url_not_in_group}/)
    @helper.freeze_externals_to_tag(tag, plugin_group)
  end

  it "#freeze_externals_to_tag should preserve frozen revision for plugins not in group, even if there's another external to modify for that parent" do
    tag = "mytag"
    external_parent = "vendor/plugins"
    plugin_group = "socialitis"
    plugin = "user"
    plugin_not_in_group = "do_not_touch"
    original_url = "https://svn.pivotallabs.com/subversion/plugins/#{plugin_group}/#{plugin}/trunk/#{plugin}"
    original_url_not_in_group = "https://svn.pivotallabs.com/subversion/plugins/pivotal_core/#{plugin_not_in_group}/trunk/#{plugin_not_in_group}"
    external_data = [
      {:name => plugin,
       :url => original_url
      },
      {:name => plugin_not_in_group,
      :revision => '6',
      :url => original_url_not_in_group
      }
    ]

    @helper.should_receive(:dirs_containing_externals).and_return([external_parent])
    @helper.should_receive(:external_data_under).with(external_parent, false).and_return(external_data)
    @helper.stub!(:uri_exists?).and_return(true)
    helper_should_propset_externals(external_parent, /#{plugin_not_in_group}\s*-r6\s*#{original_url_not_in_group}/)
    @helper.freeze_externals_to_tag(tag, plugin_group)
  end

  it "#freeze_externals_to_tag should not rewrite externals if parent has no plugins in group" do
    tag = "mytag"
    external_parent = "vendor/plugins"
    plugin_group = "socialitis"
    plugin_not_in_group = "do_not_touch"
    original_url_not_in_group = "https://svn.pivotallabs.com/subversion/plugins/pivotal_core/#{plugin_not_in_group}/trunk/#{plugin_not_in_group}"
    external_data = [
      {:name => plugin_not_in_group,
       :revision => '6',
       :url => original_url_not_in_group
      }
    ]

    @helper.should_receive(:dirs_containing_externals).and_return([external_parent])
    @helper.should_receive(:external_data_under).with(external_parent, false).and_return(external_data)
    @helper.should_not_receive(:execute)
    @helper.freeze_externals_to_tag(tag, plugin_group)
  end

  it "#freeze_externals_to_tag should fail if tag does not exist for all plugins in group" do
    tag = "mytag"
    external_parent = "vendor/plugins"
    plugin = "user"
    original_url = "https://svn.pivotallabs.com/subversion/plugins/socialitis/#{plugin}/trunk/#{plugin}"
    external_data = [
      {:name => plugin,
       :revision => '4',
       :url => original_url
      }
    ]

    @helper.should_receive(:dirs_containing_externals).and_return([external_parent])
    @helper.should_receive(:external_data_under).with(external_parent, false).and_return(external_data)
    @helper.should_receive(:uri_exists?).and_return(false)
    lambda{ @helper.freeze_externals_to_tag(tag) }.should raise_error
  end


  it "freeze__should_not_change_externals_when_already_frozen" do
    external_parent = "public/javascripts"
    external_data = [
      {:name => 'js-common',
       :revision => '555',
       :url => "repository_location"
      },
      {:name => 'js-foo',
       :revision => '666',
       :url => "repository_location_foo"
      }
    ]

    helper_should_perform_for_dir_containing_externals(external_parent, external_data)
    helper_should_propset_externals(external_parent, /js-common\s*-r555\s*repository_location\njs-foo\s*-r666\s*repository_location_foo/)
    @helper.freeze_externals
  end

  it "freeze_externals__should_still_set_externals_when_project_name_contains_dash_r" do
    external_parent = "vendor/plugins"
    external_data = [
      {:name => 'plugin-r1',
       :revision => '666',
       :url => "repository_location"
      }
    ]

    helper_should_perform_for_dir_containing_externals(external_parent, external_data)
    helper_should_propset_externals(external_parent, /plugin-r1\s*-r666\s*repository_location/)
    @helper.freeze_externals
  end

  it "freeze_externals__should_skip_blank_lines" do
    external_parent = "vendor/plugins"
    external_data = [
      {:name => 'foo',
       :revision => '4',
       :url => "loc_foo"
      },
      {:name => 'bar',
       :revision => '6',
       :url => "loc_bar"
      }
    ]

    helper_should_perform_for_dir_containing_externals(external_parent, external_data)
    helper_should_propset_externals(external_parent, /foo\s*-r4\s*loc_foo\nbar\s*-r6\s*loc_bar/)
    @helper.freeze_externals
  end

  it "#tag_externals should tag all externals in directory" do
    tag = "mytag"
    message = "message"
    external_parent = "vendor/plugins"
    foo_project_original_url = "http://host/foo_project/trunk"
    bar_project_original_url = "http://host/bar_project/branches/local"

    external_data = [
      {:name => 'foo',
       :revision => '4',
       :url => foo_project_original_url
      },
      {:name => 'bar',
       :revision => '6',
       :url => bar_project_original_url
      }
    ]

    helper_should_perform_for_dir_containing_externals(external_parent, external_data)

    foo_project_tag_url = "http://host/foo_project/tags/mytag"
    bar_project_tag_url = "http://host/bar_project/tags/mytag"

    @helper.should_receive(:tag).once.with(foo_project_original_url,
      foo_project_tag_url, /#{message}.*/, "4")
    @helper.should_receive(:tag).once.with(bar_project_original_url,
      bar_project_tag_url, /#{message}.*/, "6")

    @helper.tag_externals(tag, message)
  end

  it "tag_externals_with_timestamped_tagname" do
    initials = 'jr'
    tagname = 'tagname'
    external_parent = "vendor/plugins"
    foo_project_original_url = "http://host/foo_project/trunk"

    external_data = [
      {:name => 'foo',
       :revision => '4',
       :url => foo_project_original_url
      }
    ]

    helper_should_perform_for_dir_containing_externals(external_parent, external_data)
    foo_project_tag_url = "http://host/foo_project/tags/#{tagname}"
    @helper.should_receive(:tag).once.with(foo_project_original_url,
      foo_project_tag_url, /#{initials}.*/, "4")
    @helper.should_receive(:timestamped_tagname).once.with(initials).and_return(tagname)

    @helper.tag_externals_with_timestamped_tagname(initials)
  end

  it "#verify_tag_exists_for_base should not throw an exception if tag exists" do
    tag = 'thetag'
    tag_url = "svn+ssh://pivotal@subversion.pivotaltracker.com/subversion/#{@application}/tags/#{tag}"
    @helper.should_receive(:uri_exists?).with(tag_url).and_return(true)
    @helper.verify_tag_exists_for_base(tag)
  end
  
  it "#verify_tag_exists_for_base should throw an exception if tag does not exist" do
    tag = 'thetag'
    tag_url = "svn+ssh://pivotal@subversion.pivotaltracker.com/subversion/#{@application}/tags/#{tag}"
    @helper.should_receive(:uri_exists?).with(tag_url).and_return(false)
    lambda {
      @helper.verify_tag_exists_for_base(tag)
    }.should raise_error
  end

  it "#verify_tag_does_not_exist_for_base should throw an exception if tag does not exist" do
    tag = 'thetag'
    tag_url = "svn+ssh://pivotal@subversion.pivotaltracker.com/subversion/#{@application}/tags/#{tag}"
    @helper.should_receive(:uri_exists?).with(tag_url).and_return(true)
    lambda {
      @helper.verify_tag_does_not_exist_for_base(tag)
    }.should raise_error
  end

  it "#verify_tag_exists_for_externals should not throw an exception when tags exist for all externals" do
    tag = 'thetag'
    dir_containing_externals = "parent"
    external_data = [
      {:name => 'foo',
       :revision => '4',
       :url => "https://host/project/trunk"
      }
    ]
    helper_should_perform_for_dir_containing_externals(dir_containing_externals, external_data)
    @helper.should_receive(:uri_exists?).with("https://host/project/tags/thetag").and_return(true)
    @helper.verify_tag_exists_for_externals(tag)
  end

  it "#verify_tag_exists_for_externals should raise when tags do not exist for all externals" do
    tag = 'thetag'
    dir_containing_externals = "parent"
    external_data = [
      {:name => 'foo',
       :revision => '4',
       :url => "https://host/project/trunk"
      }
    ]
    helper_should_perform_for_dir_containing_externals(dir_containing_externals, external_data)
    @helper.should_receive(:uri_exists?).with("https://host/project/tags/thetag").and_return(false)
    lambda {
      @helper.verify_tag_exists_for_externals(tag)
    }.should raise_error
  end

  it "#verify_tag_does_not_exist_for_externals should raise when tag exists for any external" do
    tag = 'thetag'
    dir_containing_externals = "parent"
    external_data = [
      {:name => 'foo',
       :revision => '4',
       :url => "https://host/project/trunk"
      }
    ]
    helper_should_perform_for_dir_containing_externals(dir_containing_externals, external_data)
    @helper.should_receive(:uri_exists?).with("https://host/project/tags/thetag").and_return(true)
    lambda {
      @helper.verify_tag_does_not_exist_for_externals(tag)
    }.should raise_error
  end

  it "#copy_tag_including_externals should verify from tags exist, to tags do not, and invoke copy methods" do
    from_tag = 'fromtag'
    to_tag = 'totag'
    message = 'message'
  
    @helper.should_receive(:verify_tag_exists_for_base).with(from_tag)
    @helper.should_receive(:verify_tag_does_not_exist_for_base).with(to_tag)

    @helper.should_receive(:verify_tag_exists_for_externals).with(from_tag)
    @helper.should_receive(:verify_tag_does_not_exist_for_externals).with(to_tag)
    
    @helper.should_receive(:copy_tag_for_base).with(from_tag, to_tag, message)
    @helper.should_receive(:copy_tag_for_externals).with(from_tag, to_tag, message)
    
    @helper.copy_tag_including_externals(from_tag, to_tag, message)
  end

  it "#copy_tag_for_base should copy a tag for the base dir" do
    from_tag = 'fromtag'
    to_tag = 'totag'
    message = 'message'
    from_tag_url = "svn+ssh://pivotal@subversion.pivotaltracker.com/subversion/#{@application}/tags/#{from_tag}"
    to_tag_url = "svn+ssh://pivotal@subversion.pivotaltracker.com/subversion/#{@application}/tags/#{to_tag}"
    expected_command = %r{svn copy\s*#{Regexp.escape(from_tag_url)} #{Regexp.escape(to_tag_url)} -m '#{message}.*'}
    @helper.should_receive(:execute).with(expected_command)
    @helper.copy_tag_for_base(from_tag, to_tag, message)
  end
  
  it "#copy_tag_for_externals should copy tags of all externals" do
    from_tag = 'fromtag'
    to_tag = 'totag'
    message = 'message'

    dir_containing_externals = "parent"
    external_data = [
      {:name => 'foo',
       :revision => '4',
       :url => "https://host/project/trunk"
      }
    ]
    helper_should_perform_for_dir_containing_externals(dir_containing_externals, external_data)
    expected_command = %r{svn copy\s*https://host/project/tags/fromtag https://host/project/tags/totag -m '#{message}.*'}
    @helper.should_receive(:execute).with(expected_command)
    @helper.copy_tag_for_externals(from_tag, to_tag, message)
  end

  it "#external_data_under creates appropriate data" do
    external_parent = "vendor/plugins"
    helper_should_do_propget(external_parent, "foo  repository_location_foo\nbar  repository_location_bar")
    helper_should_get_revision_number("#{external_parent}/foo", "4")
    helper_should_get_revision_number("#{external_parent}/bar", "6")

    expected_results = [
      {:name => 'foo',
       :revision => '4',
       :url => 'repository_location_foo'
      },
      {:name => 'bar',
       :revision => '6',
       :url => 'repository_location_bar'
      }
    ]
    @helper.external_data_under(external_parent).should == expected_results
  end

  it "#external_data_under does not include revision if include_unfrozen_revisions is false" do
    external_parent = "vendor/plugins"
    helper_should_do_propget(external_parent, "foo -r4 repository_location_foo\nbar  repository_location_bar")

    expected_results = [
      {:name => 'foo',
       :revision => '4',
       :url => 'repository_location_foo'
      },
      {:name => 'bar',
       :url => 'repository_location_bar'
      }
    ]
    @helper.external_data_under(external_parent, false).should == expected_results
  end

  it "cleanup" do
    @helper.should_receive(:execute).once.with("svn cleanup")
    @helper.cleanup
  end


  it "update" do
    @helper.should_receive(:execute).once.with("svn update")
    @helper.update
  end

  it "execute" do
    helper = SubversionHelper.new(@repository_base, @application)
    results = helper.execute("echo hi")
    results.chomp.should == "hi"
  end

  it "get_revision_number" do
    expected_command = "svn info xxx | grep Revision | cut -f 2 -d' '"
    SubversionUtils.should_receive(:execute).ordered.with(expected_command).and_return("256")
    @helper.get_revision_number("xxx").should == "256"
  end

  it "create_version_file__file_doesnt_exist" do
    expected_commands =  [ "echo -e '$HeadURL$' > public/version.txt",
                          "svn add public/version.txt",
                          "svn propset svn:keywords \"Date Revision HeadURL\" public/version.txt",
                          "svn ci public/version.txt -m \"Adding revision file\"" ]
    @helper.should_receive(:execute).ordered.with(expected_commands[0]).and_return("")
    @helper.should_receive(:execute).ordered.with(expected_commands[1]).and_return("")
    @helper.should_receive(:execute).ordered.with(expected_commands[2]).and_return("")
    @helper.should_receive(:execute).ordered.with(expected_commands[3]).and_return("")
    @helper.should_receive(:file_exists?).once.and_return(false)
    @helper.create_version_file.should == ""
  end

  it "#dirs_containing_externals should return all unique parent dirs containing externals" do
    expected_status = <<EOS
?      .rakeTasks
?      log/mongrel_debug/files.log
X      vendor/plugins/selenium
X      vendor/plugins/other_thing
X      public/javascripts/js-common

Performing status on external item at 'public/javascripts/js-common'

Performing status on external item at 'vendor/plugins/selenium'
M      vendor/plugins/selenium/test/i_have_been_changed.rb

Performing status on external item at 'vendor/plugins/other_thing'

EOS

    @helper.should_receive(:execute).once.with("svn st").and_return(expected_status)
    dirs_containing_externals = @helper.dirs_containing_externals
    dirs_containing_externals.should == ["vendor/plugins", "public/javascripts"]
  end

  it "create_version_file__file_exists" do
    @helper.should_receive(:execute).never
    @helper.should_receive(:file_exists?).once.and_return(true)
    @helper.create_version_file.should == nil
  end

  it "delete_and_revert" do
    @helper.should_receive(:execute).once.with("rm public/version.txt; svn up public/version.txt")
    @helper.delete_and_revert("public/version.txt")
  end

  it "uri_exists_should_return_true_when_it_finds_the_uri" do
    target = "http://svn.foobar.com/trunk"
    out = ""
    sio = StringIO.new(out)
    sio.puts "Path: trunk"
    sio.puts "URL: #{target}"
    sio.puts "Repository Root: #{target}"
    sio.puts "Repository UUID: ff112490-4206-0410-a331-ceb4712babc9"
    sio.puts "Revision: 26340"
    sio.puts "Node Kind: directory"
    sio.puts "Last Changed Author: pivotal"
    sio.puts "Last Changed Rev: 26284"
    sio.puts "Last Changed Date: 2006-12-29 12:15:50 -0800 (Fri, 29 Dec 2006)"

    @helper.should_receive(:info).with(target).at_least(:once).and_return(out)
    @helper.uri_exists?(target).should == true
  end

  it "info" do
    @helper.should_receive(:execute).once.
      with("svn info some_file")
    @helper.info("some_file")
  end

  it "svn_version_with_a_real_version" do
    out = [
      "svn, version 1.4.0 (r21228)",
      "   compiled Sep 18 2006, 15:25:13",
      "",
      "Copyright (C) 2000-2006 CollabNet.",
      "Subversion is open source software, see http://subversion.tigris.org/",
      "This product includes software developed by CollabNet (http://www.Collab.Net/)."
    ].join("\n")

    @helper.should_receive(:`).with("svn --version").once.and_return(out)
    @helper.svn_version.should == "1.4.0"
  end

  it "svn_version_with_nothing" do
    @helper.should_receive(:`).with("svn --version").once.and_return("svn: : command not found")
    @helper.svn_version.should == nil
  end

  it "can_call_uri_exists_should_only_work_for_version_1_3_1_or_greater" do
    def @helper.svn_version; "1.3.1"; end
    @helper.can_call_uri_exists?.should == true

    def @helper.svn_version; "1.4.0"; end
    @helper.can_call_uri_exists?.should == true

    def @helper.svn_version; "1.0.0"; end
    @helper.can_call_uri_exists?.should_not == true

    def @helper.svn_version; nil; end
    @helper.can_call_uri_exists?.should_not == true
  end
  
  def helper_should_do_propget(filelocation, expected_propget_result)
    expected_command = "svn propget svn:externals #{filelocation}"
    @helper.should_receive(:execute).once.with(expected_command).and_return(expected_propget_result)
  end

  def helper_should_not_get_revision_number(filelocation)
    @helper.should_receive(:get_revision_number).never.with(filelocation)
  end

  def helper_should_get_revision_number(filelocation, expected_result)
    @helper.should_receive(:get_revision_number).once.with(filelocation).and_return(expected_result)
  end

  def helper_should_propset_externals(filelocation, new_externals)
    @helper.should_receive(:prop_set_svn_externals).once.with(filelocation, new_externals)
  end

  def helper_should_not_propset_externals(filelocation, new_externals)
    @helper.should_receive(:prop_set_svn_externals).never
  end
  
  def helper_should_perform_for_dir_containing_externals(dir_containing_externals, external_data)
    @helper.should_receive(:dirs_containing_externals).and_return([dir_containing_externals])
    @helper.should_receive(:external_data_under).with(dir_containing_externals).and_return(external_data)
  end

end

describe SubversionHelper, "#build_external_line" do
  it_should_behave_like("subversion helper fixture")

  before do
    @name = 'name'
    @url = 'url'
    @revision = '123'
  end
  
  it "should build an external line without a revision" do
    expected_line = "#{@name}\t\t\t#{@url}"
    line = @helper.build_external_line(@name, @url)
    line.should == expected_line
  end

  it "should build an external line with a revision" do
    expected_line = "#{@name}\t\t-r#{@revision}\t#{@url}"
    line = @helper.build_external_line(@name, @url, @revision)
    line.should == expected_line
  end
end

describe SubversionHelper, "#build_tag_url" do
  it_should_behave_like("subversion helper fixture")

  before do
    @tag = "socialitis-20070928120230-ci"
  end

  it "should convert a socialitis url with plugin name suffix" do
    original_url = "https://svn.pivotallabs.com/subversion/plugins/socialitis/user/trunk/user"
    @helper.build_tag_url(original_url, @tag).should == "https://svn.pivotallabs.com/subversion/plugins/socialitis/user/tags/socialitis-20070928120230-ci"
  end

  it "should convert a trunk url without a trailing slash" do
    original_url = "http://host/project_foo/trunk"
    @helper.build_tag_url(original_url, @tag).should == "http://host/project_foo/tags/socialitis-20070928120230-ci"
  end

  it "should convert a trunk url with a trailing slash" do
    original_url = "http://host/project_foo/trunk/"
    @helper.build_tag_url(original_url, @tag).should == "http://host/project_foo/tags/socialitis-20070928120230-ci"
  end

  it "should convert a third party local plugin format suffix" do
    original_url = "https://svn.pivotallabs.com/subversion/plugins/third_party/validates_captcha/branches/local"
    @helper.build_tag_url(original_url, @tag).should == "https://svn.pivotallabs.com/subversion/plugins/third_party/validates_captcha/tags/socialitis-20070928120230-ci"
  end

  it "should convert a tagged url name suffix" do
    original_url = "https://svn.pivotallabs.com/subversion/plugins/socialitis/user/tags/mumble"
    @helper.build_tag_url(original_url, @tag).should == "https://svn.pivotallabs.com/subversion/plugins/socialitis/user/tags/socialitis-20070928120230-ci"
  end

  it "should raise if the url format is not understood" do
    original_url = "https://svn.pivotallabs.com/subversion/plugins/socialitis/user/abc/mumble"
    lambda {
      @helper.build_tag_url(original_url, @tag)
    }.should raise_error
  end

end

describe "#build_branch_url_for_base" do
  it_should_behave_like("subversion helper fixture")

  it "should create a suitable url from the base url" do
    branch = 'thebranch'
    expected_branch_url = "svn+ssh://pivotal@subversion.pivotaltracker.com/subversion/#{@application}/branches/#{branch}"
    result = @helper.build_branch_url_for_base(branch)
    result.should == expected_branch_url
  end
end

describe "#build_branch_url_for_base" do
  it_should_behave_like("subversion helper fixture")

  it "should create a suitable url from the base url" do
    tag = 'thetag'
    expected_tag_url = "svn+ssh://pivotal@subversion.pivotaltracker.com/subversion/#{@application}/tags/#{tag}"
    result = @helper.build_tag_url_for_base(tag)
    result.should == expected_tag_url
  end
end

describe SubversionHelper, "#plugin_group_for" do
  it_should_behave_like("subversion helper fixture")

  it "should extract the plugin group from a standard pivotal plugin url" do
    original_url = "https://svn.pivotallabs.com/subversion/plugins/socialitis/user/trunk/user"
    @helper.plugin_group_for(original_url).should == "socialitis"
  end

  it "should return 'pivotal-common' if a non-standard pivotal-common url does not match the plugin group" do
    original_url = "https://svn.pivotallabs.com/subversion/pivotal-common/trunk/js-common/"
    @helper.plugin_group_for(original_url).should == 'pivotal-common'
  end

  it "should return 'unidentified_plugin_group' for a url that is not a standard pivotal plugin url" do
    junit_url = "https://svn.pivotallabs.com/subversion/jsunit/"
    random_url = "svn+ssh://randomhost/randompath"
    unidentified_plugin_group = 'unidentified_plugin_group'
    @helper.plugin_group_for(junit_url).should == unidentified_plugin_group
    @helper.plugin_group_for(random_url).should == unidentified_plugin_group
  end
end
