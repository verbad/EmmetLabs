require File.dirname(__FILE__) + '/../spec_helper'

class ShimPhoto < Asset::Photo
  has_versions :full_size => Asset::Command::Photo::ScaledDownToFit.new(1024, 768)
end

describe "A DefaultPhoto created to impersonate a ShimPhoto" do
  before(:each) do
    @default_photo = DefaultPhoto.new(ShimPhoto)
  end
  
  it "provides a correct url for the full sized version" do
    @default_photo.url(:full_size).should == "/images/default_shim_photo/full_size.png"
  end
  
  it "provides urls for all of the versions in project photo" do
    ShimPhoto.versions.keys.each do |version_name|
      @default_photo.url(version_name).should_not be_nil
    end
  end

  it "provides good simulated versions" do
    ShimPhoto.versions.keys.each do |version_name|
      @default_photo.versions[version_name].url.should_not be_nil
    end
  end

  it "raises if asked for the url of a version that isn't present in the impersonated photo class" do    
    ShimPhoto.should_not have_version(:foo)
    lambda { @default_photo.url(:foo) }.should raise_error
  end

  it "compares equally with all instances of itself" do
    DefaultPhoto.new(ShimPhoto).should == @default_photo
  end

  it "is unequal to things that differ from itself" do
    DefaultPhoto.new(ShimPhoto).should_not == ShimPhoto.new
  end
end

describe "A DefaultPhoto created to impersonate a ShimPhoto and reference images with a jpg extension" do
  before(:each) do
    @default_photo = DefaultPhoto.new(ShimPhoto, 'jpg')
  end
  
  it "provides a correct url for the full sized version" do
    @default_photo.url(:full_size).should == "/images/default_shim_photo/full_size.jpg"
  end
end
