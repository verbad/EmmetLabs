class Subscriber < ActiveRecord::Base
  validates_format_of :email_address,
                      :with => RFC::EmailAddress,
                      :message => "Invalid email address"
end