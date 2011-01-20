module CommentsHelper
  def show_more_comments_link(link_text)
    link_to_remote(link_text, :url => show_more_comments_path(@commentable),
      :update => "comments_list")
  end

  def show_more_comments_path(commentable)
    {:controller => "/comments", :action => "ajax_list",
      :commentable_id => commentable.id.to_s,
      :commentable_type => commentable.class.name}
  end
  
  def add_comments_form_options
   {:url => {:controller => "/comments", :action => "ajax_add"}, :update => "comments_list"}
  end
  
  def comments_form_hidden_fields
    hidden_field_tag('commentable_id', @commentable.id) +
    hidden_field_tag('commentable_type', @commentable.class.name)
  end

  def showing_more
    (@commentable.comments.count == @comment_list.length)
  end
end