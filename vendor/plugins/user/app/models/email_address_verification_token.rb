class EmailAddressVerificationToken < Token
  validate_on_update :not_expired
  validate_on_update :not_used
  validate_on_create :email_address_not_already_verified

  after_create :send_verification_email
  before_update :mark_as_used
  after_update :verify_email_address

  delegate :user, :to => :email_address

  alias_method :email_address, :tokenable
  alias_method :email_address=, :tokenable=

  private
  def email_address_not_already_verified
    errors.add(:email_address, "This email address has already been validated".customize) if email_address.verified?
  end

  def send_verification_email
    EmailMailer.deliver_email_address_verification_request(self)
  end

  def verify_email_address
    email_address.verified = true
    email_address.save
  end

  def not_expired
    errors.add(:expired, "User validation request has expired".customize) if expired?
  end

  def not_used
    errors.add(:used, "User validation request has already been used".customize) if used?
  end

  def mark_as_used
    self.used = true
  end

end