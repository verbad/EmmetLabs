require File.dirname(__FILE__) + '/../spec_helper'

describe Photo do

  it "should be a photo" do
    photo = Photo.new
    photo.should be_photo
    photo.type.should == Photo.to_s
  end

  it "should support comments" do
    photo = assets(:photo_1)
    photo.comments.size.should == 1
    photo.comments.first.text.should == 'comment on a photo'
  end

  it "should know if it is primary" do
    assets(:photo_1).should be_primary
    assets(:photo_2).should_not be_primary
  end

  it "should support adding comments" do
    photo = Photo.new(:source_uri => 'http://www.example.com/foo.gif')
    photo.save!
    photo.comments.create!(:text => 'a comment', :author_id => 1)
    photo.reload
    photo.comments.size.should == 1
  end

  it "should know its comment" do
    photo = Photo.new(:source_uri => 'http://www.example.com/foo.gif')
    photo.comments.build(:text => 'comment 1', :author_id => 1)
    photo.comments.build(:text => 'comment 2', :author_id => 1)
    photo.comment.text.should == 'comment 1'
  end

  it "should know its comment is nil when there are no comments" do
    photo = Photo.new(:source_uri => 'http://www.example.com/foo.gif')
    photo.comment.should be_nil
  end

end
