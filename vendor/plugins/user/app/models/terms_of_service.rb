class TermsOfService < ActiveRecord::Base
  acts_as_list :column => :revision

  validates_presence_of :text, :message => "Text cannot be blank".customize
  
  def self.latest
    find(:first, :order => 'revision DESC')
  end

  def self.latest?(tos)
    TermsOfService.latest.nil? || TermsOfService.latest == tos
  end

  def self.defined?
    0 != self.count
  end

  def readable_by?(user)
    true
  end
  
  def creatable_by?(user)
    user.super_admin?
  end

  def updatable_by?(user)
    user.super_admin?
  end

  def destroyable_by?(user)
    user.super_admin?
  end

end