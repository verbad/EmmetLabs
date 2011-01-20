class EmailMailer < ActionMailer::Base
  def password_reset_request(user, token, options = {})
    raise "User needs a valid reset password token" unless token

    about = options[:subject] || "Example: Reset Your Password"
    whom = options[:from] || EmailMailer.admin_address
    recipients user.email_address
    subject about
    from whom
    multipart("email_mailer/password_reset_request", :token => token)
  end

  def email_address_verification_request(token, options = {})
    about = options[:subject] || "Please validate your account"
    whom = options[:from] || EmailMailer.admin_address
    recipients token.email_address.address
    subject about
    from whom
    multipart("email_mailer/email_address_verification_request", :token => token)
  end

  def self.admin_address
    "'Example Admin' <noreply@example.com>"
  end
end
