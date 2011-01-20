module ControllerCanListComments
  def self.included(base)
    base.helper :comments
  end

  def load_comments_list(commentable, show_all = false)
    @commentable = commentable
    @comment_list = @commentable.comments.latest(show_all ? nil : 5)
  end

end