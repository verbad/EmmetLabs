dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

describe "A ThirdPartyPlugin" do
  before do
    @plugin = ThirdPartyPlugin.new("fake",
      :remote_repository_root => "svn:whatever")
    @local_svn_root = "https://svn.pivotallabs.com/subversion/plugins/third_party/fake"
    SubversionUtils.stub!(:execute).and_return {raise "Neutered execute"}
    @plugin.stub!(:say)
  end

  it "should initialize" do
    @plugin.name.should == "fake"
    @plugin.repository_root.should == "https://svn.pivotallabs.com/subversion/plugins/third_party/fake"
    @plugin.remote_repository_root.should == "svn:whatever"
    @plugin.options[:vendor_tag_name].should be_nil
  end

  it "should install" do
    msg = "-m 'rake third_party:install - plugin fake installed from svn:whatever'"
    SubversionUtils.should_receive(:execute).ordered.
      with("svn info svn:whatever | grep Revision | cut -f 2 -d' '").and_return("25")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn mkdir #{@local_svn_root} #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn mkdir #{@local_svn_root}/branches #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn mkdir #{@local_svn_root}/tags #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn export svn:whatever . --force --revision=25")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn import . #{@local_svn_root}/tags/vendor_rev_25 #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/vendor_rev_25 #{@local_svn_root}/branches/vendor #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/vendor_rev_25 #{@local_svn_root}/tags/local_sprout_from_vendor_rev_25 #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/local_sprout_from_vendor_rev_25 #{@local_svn_root}/branches/local #{msg}")
    @plugin.install
  end

  it "should not allow you to update without providing a prior vendor tag" do
    lambda {@plugin.update}.should raise_error(RuntimeError, /Please provide.*PRIOR_VENDOR_TAG_NAME/)
  end
end

describe "A ThirdPartyPlugin with a prior vendor tag" do
  before do
    @plugin = ThirdPartyPlugin.new("fake",
      :remote_repository_root => "svn:whatever", :prior_vendor_tag_name => 'vendor_rev_15')
    @local_svn_root = "https://svn.pivotallabs.com/subversion/plugins/third_party/fake"
    SubversionUtils.stub!(:execute).and_return {raise "Neutered execute"}
    @plugin.stub!(:say)
  end

  it "should update" do
    msg = "-m 'rake third_party:update - updated to tag vendor_rev_25'"
    SubversionUtils.should_receive(:execute).ordered.
      with("svn diff #{@local_svn_root}/tags/local_sprout_from_vendor_rev_15 #{@local_svn_root}/branches/local").and_return('  ')
    SubversionUtils.should_receive(:execute).ordered.
      with("svn info svn:whatever | grep Revision | cut -f 2 -d' '").and_return("25")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn export svn:whatever . --force --revision=25")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn import . #{@local_svn_root}/tags/vendor_rev_25 #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn rm #{@local_svn_root}/branches/vendor #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/vendor_rev_25 #{@local_svn_root}/branches/vendor #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/vendor_rev_25 #{@local_svn_root}/tags/local_sprout_from_vendor_rev_25 #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/local_sprout_from_vendor_rev_25 #{@local_svn_root}/branches/local #{msg}")
    @plugin.update
  end

  it "should raise exception on update if changes exist on local branch and DELETE_LOCAL_BRANCH_CHANGES is not true" do
    SubversionUtils.should_receive(:execute).ordered.
      with("svn diff #{@local_svn_root}/tags/local_sprout_from_vendor_rev_15 #{@local_svn_root}/branches/local").and_return('some diffs')
    lambda {@plugin.update}.should raise_error(RuntimeError, /changes exist.*DELETE_LOCAL_BRANCH_CHANGES/i)
  end

  it "should raise exception when attempting to update to same vendor tag as currently exists" do
    msg = "-m 'rake third_party:update - updated to tag vendor_rev_25'"
    SubversionUtils.should_receive(:execute).ordered.
      with("svn diff #{@local_svn_root}/tags/local_sprout_from_vendor_rev_15 #{@local_svn_root}/branches/local").and_return('  ')
    SubversionUtils.should_receive(:execute).ordered.
      with("svn info svn:whatever | grep Revision | cut -f 2 -d' '").and_return("15")
    lambda {@plugin.update}.should raise_error(RuntimeError, /vendor tag vendor_rev_15 already exists/i)
  end
end

describe "A ThirdPartyPlugin that uses to a vendor tag rather than a revision" do
  before do
    @vendor_tag_name = "vendor_tag"
    @prior_vendor_tag_name = "prior_vendor_tag"
    @plugin = ThirdPartyPlugin.new("fake",
      :remote_repository_root => "svn:whatever",
      :vendor_tag_name => @vendor_tag_name)
    @local_svn_root = "https://svn.pivotallabs.com/subversion/plugins/third_party/fake"
    SubversionUtils.stub!(:execute).and_return {raise "Neutered execute"}
    @plugin.stub!(:say)
  end

  it "should install to a vendor tag named after itself" do
    msg = "-m 'rake third_party:install - plugin fake installed from svn:whatever'"
    SubversionUtils.should_receive(:execute).ordered.
      with("svn info svn:whatever | grep Revision | cut -f 2 -d' '").and_return("25")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn mkdir #{@local_svn_root} #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn mkdir #{@local_svn_root}/branches #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn mkdir #{@local_svn_root}/tags #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn export svn:whatever . --force --revision=25")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn import . #{@local_svn_root}/tags/vendor_tag #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/vendor_tag #{@local_svn_root}/branches/vendor #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/vendor_tag #{@local_svn_root}/tags/local_sprout_from_vendor_tag #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/local_sprout_from_vendor_tag #{@local_svn_root}/branches/local #{msg}")
    @plugin.install
  end

  it "should diff local branch against a vendor tag" do
    diff_output = "diff output"
    SubversionUtils.should_receive(:execute).
      with("svn diff #{@local_svn_root}/tags/local_sprout_from_#{@vendor_tag_name} #{@local_svn_root}/branches/local").and_return(diff_output)
    @plugin.local_branch_diff.should == diff_output
  end
end

describe "A ThirdPartyPlugin with a prior vendor tag that uses to a vendor tag rather than a revision" do
  before do
    @vendor_tag_name = "vendor_tag"
    @prior_vendor_tag_name = "prior_vendor_tag"
    @plugin = ThirdPartyPlugin.new("fake",
      :remote_repository_root => "svn:whatever",
      :vendor_tag_name => @vendor_tag_name, :prior_vendor_tag_name => @prior_vendor_tag_name)
    @local_svn_root = "https://svn.pivotallabs.com/subversion/plugins/third_party/fake"
    SubversionUtils.stub!(:execute).and_return {raise "Neutered execute"}
    @plugin.stub!(:say)
  end

  it "should update to a vendor tag named after itself" do
    msg = "-m 'rake third_party:update - updated to tag vendor_tag'"
    SubversionUtils.should_receive(:execute).ordered.
      with("svn diff #{@local_svn_root}/tags/local_sprout_from_#{@prior_vendor_tag_name} #{@local_svn_root}/branches/local").and_return('')
    SubversionUtils.should_receive(:execute).ordered.
      with("svn info svn:whatever | grep Revision | cut -f 2 -d' '").and_return("25")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn export svn:whatever . --force --revision=25")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn import . #{@local_svn_root}/tags/vendor_tag #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn rm #{@local_svn_root}/branches/vendor #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/vendor_tag #{@local_svn_root}/branches/vendor #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/vendor_tag #{@local_svn_root}/tags/local_sprout_from_vendor_tag #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/local_sprout_from_vendor_tag #{@local_svn_root}/branches/local #{msg}")
    @plugin.update
  end

end

describe "A ThirdPartyPlugin that doesn't start from a plugin directory" do
  before do
    @plugin = ThirdPartyPlugin.new("fake",
      :remote_repository_root => "svn:whatever", :no_root_dir => true, :prior_vendor_tag_name => 'vendor_rev_15')
    @local_svn_root = "https://svn.pivotallabs.com/subversion/plugins/third_party/fake"
    SubversionUtils.stub!(:execute).and_return {raise "Neutered execute"}
    @plugin.stub!(:say)
  end

  it "should export into a subdirectory that matches the plugin name" do
    msg = "-m 'rake third_party:update - updated to tag vendor_rev_25'"
    SubversionUtils.should_receive(:execute).ordered.
      with("svn diff #{@local_svn_root}/tags/local_sprout_from_vendor_rev_15 #{@local_svn_root}/branches/local").and_return('  ')
    SubversionUtils.should_receive(:execute).ordered.
      with("svn info svn:whatever | grep Revision | cut -f 2 -d' '").and_return("25")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn export svn:whatever fake --force --revision=25")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn import . #{@local_svn_root}/tags/vendor_rev_25 #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn rm #{@local_svn_root}/branches/vendor #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/vendor_rev_25 #{@local_svn_root}/branches/vendor #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/vendor_rev_25 #{@local_svn_root}/tags/local_sprout_from_vendor_rev_25 #{msg}")
    SubversionUtils.should_receive(:execute).ordered.
      with("svn cp #{@local_svn_root}/tags/local_sprout_from_vendor_rev_25 #{@local_svn_root}/branches/local #{msg}")
    @plugin.update
  end
end
