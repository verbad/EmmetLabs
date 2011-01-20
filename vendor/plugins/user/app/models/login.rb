class Login < ActiveRecord::Base
  belongs_to :user

  attr_accessor :email_address, :password

  acts_as_paranoid unless Object.const_defined?(:DISABLE_ACTS_AS_PARANOID)
  validate_on_create :credentials_are_correct, :not_disabled
  validates_acceptance_of :accept_terms_of_service, :allow_nil => false,
                          :message => "Terms of service must be accepted".customize,
                          :if => lambda {|record| record.needs_to_accept_tos?},
                          :on => :create

  after_create :increment_tos
  before_validation :setup_user

  def needs_to_accept_tos?
    user && user.needs_to_accept_tos?
  end
  
  private
  def credentials_are_correct
    errors.add(:password, "Email address and password do not match".customize) if !user
  end
  
  def not_disabled
    errors.add_to_base("This user account is disabled.") if user && user.disabled?
  end
  
  def setup_user
    self.user ||= User.authenticate(:email_address => email_address, :password => password)
  end

  def increment_tos
    if needs_to_accept_tos?
      user.accept_terms_of_service = accept_terms_of_service
      user.save
    end
  end
end
