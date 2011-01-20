module CanBeReviewed
  def self.included(base)
    base.has_many :reviews, :as => :topic, :order => "created_at DESC"
  end

  def average_rating
    total = reviews.inject(0) {|sum, review| sum + review.rating}
    ((total*2.0) / reviews.count).round / 2.0
  end
end