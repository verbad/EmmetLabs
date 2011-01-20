require 'digest/sha2'

class Token < ActiveRecord::Base
  belongs_to :tokenable, :polymorphic => true
  validates_uniqueness_of :token, :message => "Guid must be unique".customize
  validates_length_of :token, :maximum => 255, :if => lambda {|record| !record.token.blank?}

  before_create :set_token
  before_create :set_expiration

  def set_token
    self.token = Guid.new.to_s
  end
  
  def set_expiration
    self.expires_at = Time.now + self.class.time_to_live
  end
    
  def self.time_to_live
     48.hours
  end

  def expired?
    expires_at <= Time.now
  end
  
  def to_param
    token
  end
  
  def to_s
    self.token
  end

  def self.find_by_param(*args)
    find_by_token *args
  end
end
