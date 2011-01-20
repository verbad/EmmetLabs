class CommentsController < ApplicationController
  include ControllerCanListComments

  def ajax_list
    load_comments_list(load_commentable_from_params, true)
    @comment_list = @commentable.comments.latest
    render_ajax_list
  end
  
  def ajax_add
    commentable = load_commentable_from_params
    if logged_in?
      current_user.add_comment_about(commentable, params[:text])
      commentable.reload
    else
      flash.now[:error] = "You need to be logged in to add a comment."
    end
    load_comments_list(commentable)
    render_ajax_list
  end
  
  protected
  
  def load_commentable_from_params
    params[:commentable_type].constantize.find(params[:commentable_id])
  end
  
  def render_ajax_list
    render :partial => "ajax_list"
  end
end