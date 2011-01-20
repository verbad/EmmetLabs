class EmailMailer < ActionMailer::Base
  def self.admin_address
    "'Emmet Labs' <contact@emmetlabs.com>"
  end
end
