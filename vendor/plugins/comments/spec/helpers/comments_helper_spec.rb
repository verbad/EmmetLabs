require File.dirname(__FILE__) + "/../spec_helper"

describe 'The comment helper' do
  helper_name 'comments'

  fixtures :commentable_shims

  before(:each) do
    @commentable = commentable_shims(:fan)
  end

  it 'should support showing more comments' do
    url = show_more_comments_path(@commentable)
    url.should == {:controller => "/comments", :action => "ajax_list", :commentable_id => @commentable.id.to_s, :commentable_type => "CommentableShim"}
  end

  it 'should support showing even more comments' do
    stub!(:show_more_comments_path).and_return {"path"}
    html = show_more_comments_link('foo')
    html.should == "<a href=\"#\" onclick=\"new Ajax.Updater('comments_list', 'path', {asynchronous:true, evalScripts:true}); return false;\">foo</a>"
  end
end

