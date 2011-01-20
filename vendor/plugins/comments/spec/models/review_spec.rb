require File.dirname(__FILE__) + "/../spec_helper"

describe "Users" do
  fixtures :users, :comments, :commentable_shims
  
  before(:each) do
    @user = users(:eye)
    @user_review = comments(:eye_need_glasses)
    @fan = commentable_shims(:fan)
    @now = Time.local(2006, 'Jan', 1)
    Time.stub!(:now).and_return {@now}
  end

  it "should be able to list the things they've rated" do
    @user.reviews_i_wrote.should == [@user_review]
  end

  it "should be able to remove reviews they've written" do
    @user.remove_review(@user_review)
    @user.reviews_i_wrote.should == []
  end

  it "should be able to review a reviewable" do
    @user.add_review_about(@fan, "Fans are so cool", 3)
    @user.reload
    review = @user.reviews_i_wrote.last
    review.text.should == "Fans are so cool"
    review.author.should == @user
    review.topic.should == @fan
    review.rating.should == 3
    review.created_at.should == @now
    review.updated_at.should == @now
  end
end

describe "Reviewables" do
  fixtures :commentable_shims, :comments, :users

  before(:each) do
    @glasses = commentable_shims(:glasses)
    @fan = commentable_shims(:fan)
  end

  it "should be able to list their reviews" do
    @glasses.reviews.should == [comments(:eye_need_glasses)]
  end

  it "should be able to calculate their average review rating rounded to the nearest .5" do
    @fan.reviews.should == []
    users(:eye).add_review_about(@fan, "Foo", 2)
    @fan.reload
    @fan.average_rating.should == 2.0

    users(:me).add_review_about(@fan, "Foo", 5)
    @fan.reload
    @fan.average_rating.should == 3.5

    users(:myself).add_review_about(@fan, "Foo", 4)
    @fan.reload
    @fan.average_rating.should == 3.5 # 3.66

    users(:myself).add_review_about(@fan, "Foo", 4)
    @fan.reload
    @fan.average_rating.should == 4.0 # 3.75

  end
end

