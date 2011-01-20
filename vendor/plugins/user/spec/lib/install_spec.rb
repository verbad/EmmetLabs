require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../plugin_installer'

describe "install script" do
  before do
    @plugin_root = File.expand_path(File.dirname(__FILE__) + "/../../")
  end

  # TODO: make this test pass, write tests for other functions of install.rb
  it "copies default profile pics to app" #do
#    profile_pic = "#{@plugin_root}/tmp/public/images/default_profile_photo/avatar.png"
#    profile_pic2 = "#{@plugin_root}/tmp/public/images/default_profile_photo/original.png"
#    File.exists?(profile_pic).should_not be_true
#    File.exists?(profile_pic2).should_not be_true
#
#    installer = PluginInstaller::Installer.new(@plugin_root)
#    installer.run
#
#    File.exists?(profile_pic).should be_true
#    File.exists?(profile_pic2).should be_true
#  end

#  after do
#    FileUtils.rm_rf(@plugin_root + '/tmp')
#  end
end
