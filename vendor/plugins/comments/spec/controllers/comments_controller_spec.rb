require File.dirname(__FILE__) + "/../spec_helper"

describe "A comment controller" do
  controller_name 'comments'
  fixtures :commentable_shims, :users
  
  before(:each) do
    @commentable = commentable_shims(:glasses)
    log_in users(:me)
  end

  it "can list all comments for a commentable as a partial" do
    xhr :post, :ajax_list, :commentable_id => @commentable.id.to_s,
      :commentable_type => @commentable.class.name.to_s
    response.should render_template("_ajax_list")
    assigns(:comment_list).should == @commentable.comments
  end
  
  it "Can only add a comment if logged in" do
    log_out
    old_count = @commentable.comments.count
    
    xhr :post, :ajax_add, :text => "My comment",
      :commentable_id => @commentable.id.to_s,
      :commentable_type => @commentable.class.name.to_s
    response.should render_template("_ajax_list")

    @commentable.reload
    @commentable.comments.count.should == old_count
  end

  it "can add a comment to a commentable as a partial" do
    xhr :post, :ajax_add, :text => "My comment",
      :commentable_id => @commentable.id.to_s,
      :commentable_type => @commentable.class.name.to_s
      
    @commentable.reload
    latest_comment = @commentable.comments.latest.first
    latest_comment.text.should == "My comment"
    latest_comment.author.should == users(:me)
    assigns(:comment_list).first.should == latest_comment
  end

end