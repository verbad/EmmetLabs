class PasswordResetToken < Token
  def send_password_reset_email
    EmailMailer.deliver_password_reset_request(user, self, {:subject => 'Reset your Emmet password', :from => 'feedback@emmetlabs.com'})
  end
end