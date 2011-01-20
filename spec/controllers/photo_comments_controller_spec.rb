require File.dirname(__FILE__) + '/../spec_helper'

describe PhotoCommentsController do
  it_should_behave_like 'login'
  
  before do
    @photo = assets(:photo_1)
  end

  it "should handle create with text" do
    initial_count = @photo.comments.size
    post :create, :photo_id => @photo.id, :comment => {:text=>'a new comment'}
    assigns(:photo).comments.last.errors.should be_empty
    assigns(:photo).comments.last.should == assigns(:comment)
    @photo.reload
    @photo.comments.size.should == initial_count + 1
    @photo.comments.last.text.should == 'a new comment'
  end

  it "should handle create without text" do
    initial_count = @photo.comments.size
    post :create, :photo_id => @photo.id, :comment => {:text=>''}
    assigns(:photo).comments.last.errors.should_not be_empty
    assigns(:photo).comments.last.should == assigns(:comment)
    @photo.reload
    @photo.comments.size.should == initial_count
  end

  it "should handle updating a comment with text" do
    existing_comment = comments(:photo_1_comment)
    existing_comment.topic.should == @photo
    initial_count = @photo.comments.size
    put :update, :photo_id => @photo.id, :id => existing_comment.id, :comment => {:text=>'qwerty'}
    assigns(:photo).comments.size.should == initial_count
    assigns(:comment).text.should == 'qwerty'
    @photo.reload
    @photo.comments.size.should == initial_count
    existing_comment.reload
    existing_comment.text.should == 'qwerty'
  end

  it "should handle updating a comment without text" do
    existing_comment = comments(:photo_1_comment)
    initial_text = existing_comment.text
    existing_comment.topic.should == @photo
    initial_count = @photo.comments.size
    put :update, :photo_id => @photo.id, :id => existing_comment.id, :comment => {:text=>''}
    assigns(:photo).comments.size.should == initial_count
    assigns(:comment).errors.should_not be_empty
    @photo.reload
    @photo.comments.size.should == initial_count
    existing_comment.reload
    existing_comment.text.should == initial_text
  end

end

describe PhotoCommentsController do
  it "should require login" do
    post :create, :photo_id => assets(:photo_1).id
    response.response_code.should == 302
  end
end