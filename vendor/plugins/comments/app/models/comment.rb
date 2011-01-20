class Comment < ActiveRecord::Base
  belongs_to :author, :polymorphic => true
  belongs_to :topic, :polymorphic => true

  validates_length_of :text, :minimum=>1, :on => :save, :message => "You can't leave a blank comment"
  
  before_create do |record|
    record.type = record.class.name unless record.type
    record.author_type = 'User' unless record.author_type
  end
  
  acts_as_paranoid unless Object.const_defined?(:DISABLE_ACTS_AS_PARANOID)
end