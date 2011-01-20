require File.dirname(__FILE__) + "/../spec_helper"

describe "Users" do
  fixtures :users, :comments, :commentable_shims
  
  before(:each) do
    @user = users(:myself)
    @user_comment = comments(:myself_and_my_glasses)
    @fan = commentable_shims(:fan)
    @now = Time.local(2006, 'Jan', 1)
    Time.stub!(:now).and_return {@now}
  end

  it "should be able to list the comments they wrote" do
    @user.comments_i_wrote.each {|comment|
      comment.class.should == Comment
      comment.author.should == @user
    }

    @user.comments_i_wrote.should include(@user_comment)
  end

  it "should be able to remove comments they've written" do
    @user.remove_comment(@user_comment)
    @user.comments_i_wrote.should == []
  end

  it "should be able to comment a commentable" do
    @user.add_comment_about(@fan, "Fans are so cool")
    comment = @user.comments_i_wrote.last
    comment.text.should == "Fans are so cool"
    comment.author.should == @user
    comment.topic.should == @fan
    comment.created_at.should == @now
    comment.updated_at.should == @now
  end
end

describe "commentables" do
  fixtures :commentable_shims, :comments, :users

  before(:each) do
    @glasses = commentable_shims(:glasses)
    @fan = commentable_shims(:fan)
    @user = users(:myself)
  end

  it "should be able to list their comments" do
    @glasses.comments.should == [comments(:eye_need_glasses), comments(:myself_and_my_glasses)]
  end
  
  it "should be able to show latest or earliest comments" do
    @fan.comments.should == []
    10.times do |index|
      count = index + 1
      Time.stub!(:now).and_return {Time.local(2006, "Mar", count)}
      @user.add_comment_about(@fan, "Fan comment #{count}")
    end
    @fan.reload
    @fan.comments.latest(2).collect {|c|c.text}.should ==(["Fan comment 10", "Fan comment 9"])
    @fan.comments.earliest(3).collect {|c|c.text}.should ==(["Fan comment 1", "Fan comment 2", "Fan comment 3"])
    latest_comments = @fan.comments.latest
    latest_comments.length.should == 10
    latest_comments.first.text.should == "Fan comment 10"
    
    earliest_comments = @fan.comments.earliest
    earliest_comments.length.should == 10
    earliest_comments.first.text.should == "Fan comment 1"
  end
end

