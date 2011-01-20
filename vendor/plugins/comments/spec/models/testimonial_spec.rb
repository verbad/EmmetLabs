require File.dirname(__FILE__) + "/../spec_helper"

describe "Users with testimonials written about them" do
  fixtures :users, :comments
  
  before(:each) do
    @user = users(:myself)
  end

  it "should be able to list testimonials about them" do
    @user.testimonials.should == [comments(:me_like_myself), comments(:eye_hate_myself)]
  end

  it "should not be able to add testimonials to themselves" do
    lambda {@user.add_testimonial_about(@user, "I'm going to bolster my profile by talking about myself")}.should raise_error(NotAllowedError)
  end

  it "should be able to remove testimonials written about themselves" do
    @user.remove_testimonial(comments(:eye_hate_myself))
    @user.testimonials.should == [comments(:me_like_myself)]
  end

end

describe "Users who can write testimonials" do
  fixtures :commentable_shims, :comments, :users

  before(:each) do
    @now = Time.local(2006, 'Mar', 1)
    @user = users(:me)
    @user_2 = users(:myself)
    @user_3 = users(:eye)
    Time.stub!(:now).and_return {@now}
  end

  it "should be able to add testimonials about other people" do
    @user_3.testimonials.should == []
    @user.add_testimonial_about(@user_3, "Eye look good!")
    @user_3.reload
    @user_3.testimonials.length.should == 1
    testimonial = @user_3.testimonials.first
    testimonial.text.should == "Eye look good!"
    testimonial.author.should == @user
    testimonial.topic.should == @user_3
    testimonial.created_at.should == @now
    testimonial.updated_at.should == @now
  end

  it "should know what testimonials they wrote" do
    @user.testimonials_i_wrote.should == [comments(:me_like_myself)]
  end

  it "should be able to remove testimonials they wrote" do
    @user.testimonials_i_wrote.should == [comments(:me_like_myself)]
    @user.remove_testimonial(comments(:me_like_myself))
    @user.testimonials_i_wrote.should == []
  end

  it "should not be able to delete testimonials they didn't write, and that aren't about them" do
    testimonial = comments(:me_like_myself)
    @user_3.should_not ==(testimonial.author)
    @user_3.should_not ==(testimonial.topic)

    lambda{@user_3.remove_testimonial(testimonial)}.should raise_error(NotAllowedError)
  end

end