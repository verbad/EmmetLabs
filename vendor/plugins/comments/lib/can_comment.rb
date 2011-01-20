module CanComment
  def self.included(base)
    raise "You can only use this plugin with the User class" unless base == User

    base.has_many :testimonials_i_wrote, :as => :author, :class_name => "Testimonial", :dependent => :destroy
    base.has_many :testimonials, :as => :topic, :dependent => :destroy
    base.has_many :reviews_i_wrote, :as => :author, :class_name => "Review", :dependent => :destroy
    base.has_many :comments_i_wrote, :as => :author, :class_name => "Comment", :dependent => :destroy
  end

  def add_testimonial_about(user, text)
    raise NotAllowedError if user == self
    testimonials_i_wrote.create(:topic => user, :text => text)
  end

  def remove_testimonial(testimonial)
    raise NotAllowedError unless self == testimonial.author || self == testimonial.topic
    testimonial.destroy
    reload
  end

  def add_review_about(commentable, text, rating)
    reviews_i_wrote.create(:topic => commentable, :text => text, :rating => rating)
  end

  def remove_review(review)
    raise NotAllowedError unless self == review.author
    reviews_i_wrote.delete(review)
  end

  def add_comment_about(user, text)
    comments_i_wrote.create(:topic => user, :text => text)
  end

  def remove_comment(comment)
    raise NotAllowedError unless self == comment.author
    comments_i_wrote.delete(comment)
  end

end