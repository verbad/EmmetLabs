class PasswordResetToken < Token
  validate_on_update :not_expired, :not_used
  validates_presence_of :user, :message => "Password Reset Token must belong to a user".customize
  validates_associated :user, :message => "Password does not match confirmation".customize
  validate :account_is_verified

  before_update :mark_as_used
  before_update :update_user
  after_create :send_password_reset_email

  delegate :password, :password=, :password_confirmation, :password_confirmation=, :to => :user

  alias_method :user, :tokenable
  alias_method :user=, :tokenable=

  private
  def mark_as_used
    self.used = true
  end

  def update_user
    user.save
  end

  def send_password_reset_email
    EmailMailer.deliver_password_reset_request(user, self)
  end

  def not_expired
    errors.add(:expired, "Password change request has expired".customize) if expired?
  end

  def not_used
    errors.add(:used, "Password change request has already been used".customize) if used?
  end

  def account_is_verified
    if user && !user.account_verified?
      errors.add(:account_verified, "This account has not yet been validated. Please check your email".customize)
    end
  end
end