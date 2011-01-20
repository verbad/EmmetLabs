class NewUserEmailer < ActionMailer::Base
  def welcome(user, password)
    recipients user.primary_email_address
    subject "Welcome to Emmet"
    from 'Emmet Labs <feedback@emmetlabs.com>'
    multipart("welcome", {:user => user, :password => password})
  end
end
